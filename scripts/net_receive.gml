///net_receive(eventtype,ds_list)
var recvip;

if (argument0!=network_type_data) {
    if (argument0==network_type_connect) {
        recvip = ds_map_find_value(async_load, "ip");
        if (ds_map_exists(netsockets_unknown, recvip)==true) {
            network_destroy(ds_map_find_value(netsockets_unknown, recvip));
            network_destroy(socket);
            ds_map_delete(netsockets_unknown, recvip);
        } else {
            ds_map_add(netsockets_unknown, recvip, socket);
        }
    }
    exit;
}

var recvlist, recvtype, recvid, recvmsg, recvip, recvport, recvkey;
recvlist = argument1;
recvtype = real(ds_list_find_value(recvlist, 0));
ds_list_delete(recvlist, 0);
recvid = ds_list_find_value(recvlist, 0);
ds_list_delete(recvlist, 0);
recvmsg = real(ds_list_find_value(recvlist, 0));
ds_list_delete(recvlist, 0);
recvport = real(ds_list_find_value(recvlist, 0));
ds_list_delete(recvlist, 0);
recvkey = ds_list_find_value(recvlist, 0);
ds_list_delete(recvlist, 0);

switch (recvtype) {
    case NET_TCP:
    case NET_UDP:
    case NET_BROADCAST:
        recvip = ds_map_find_value(async_load, "ip");
        break;
    case NET_HTTP:
        recvip = ds_map_find_value(async_load, "url");
        break;
}

switch (recvmsg) {
    case MSG_CONN:
        ///SERVER
        if (ds_map_exists(netsockets_unknown, recvip)==true) {
            var socket = ds_map_find_value(netsockets_unknown, recvip);
            ds_map_delete(netsockets_unknown, recvip);
        } else {
            switch (recvtype) {
                case NET_BROADCAST:
                case NET_UDP:
                    var socket = network_create_socket(network_socket_udp);
                    break;
                case NET_TCP:
                    exit;
                case NET_HTTP:
                    var socket = -1;
                    break;
            }
        }
        ds_list_add(netsockets, socket);
        ds_list_add(netsockets_id, recvid);
        ds_list_add(netsockets_ip, recvip);
        ds_list_add(netsockets_port, recvport);
        ds_list_add(netsockets_type, recvtype);
        ds_list_add(netsockets_acc, true);
        break;
        
    case MSG_CONNACCEPT:
        ///CLIENT
        pos = ds_list_find_index(netsockets_id, recvid);
        if (pos<0) return -1;
        ds_list_replace(netsockets_acc, pos, true);
        
    case MSG_DISCONN:
        ///SERVER
        var pos = ds_list_find_index(netsockets_id, recvid);
        if (pos<0) break;
        
        switch (recvtype) {
            case NET_BROADCAST:
            case NET_UDP:
            case NET_TCP:
                var socket, buffer;
                socket = ds_list_find_value(netsockets, pos);
                network_destroy(socket);
                break;
            case NET_HTTP:
                break;
        }
        ds_list_delete(netsockets, pos);
        ds_list_delete(netsockets_id, pos);
        ds_list_delete(netsockets_ip, pos);
        ds_list_delete(netsockets_port, pos);
        ds_list_delete(netsockets_type, pos);
        ds_list_delete(netsockets_acc, pos);
        break;
        
    case MSG_PING:
        ///SERVER
        ds_list_clear(datalist);
        if (ds_list_find_index(netsockets_id, recvid)==-1) {
            net_push(NET_UDP, recvip, recvport, MSG_PONG, datalist, udpport, global.key);
        } else {
            net_send(recvid, MSG_PONG, datalist, udpport, global.key);
        }
        break;
        
    case MSG_PONG:
        ///CLIENT
        //pass
        break;
        
    case MSG_GETIP:
        ///CLIENT
        if (recvtype==NET_HTTP) {
            if (ds_list_find_value(recvlist, 0)==md5_string_unicode(pubhash) && pubhash!="-1") {
                publicip = ds_list_find_value(recvlist, 1);
                pubhash = "-1";
            }
        } else {
            if (ds_list_find_value(recvlist, 0)==md5_string_unicode(lanhash) && lanhash!="-1") {
                lanip = recvip;
                lanhash = "-1";
            }
        }
        break;
        
    case MSG_INFOREQUEST:
        ///SERVER
        ds_list_clear(datalist);
        ds_list_add(datalist, 0);
        ds_list_add(datalist, global.name);
        ds_list_add(datalist, global.port);
        if (ds_list_find_index(netsockets_id, recvid)==-1) {
            net_push(NET_UDP, recvip, recvport, MSG_INFO, datalist, udpport, global.key);
        } else {
            net_send(recvid, MSG_INFO, datalist, udpport, global.key);
        }
        break;
        
    case MSG_INFO:
        ///CLIENT
        var recvlan = real(ds_list_find_value(recvlist, 0));
        var recvname = ds_list_find_value(recvlist, 1);
        var recvgameport = real(ds_list_find_value(recvlist, 2));
        if (recvlan==true) {
            if (ds_list_find_index(lan_key, recvkey)<0 && global.key!=recvkey) {
                ds_list_add(lan_key, recvkey);
                ds_list_add(lan_ip, recvip);
                ds_list_add(lan_port, recvgameport);
                ds_list_add(lan_name, recvname);
                ds_list_add(lan_req, 0);
                show_debug_message("New server found at: "+recvip+"   called: "+recvname);
            }
        } else {
            if (ds_list_find_index(own_key, recvkey)<0 && global.key!=recvkey) {
                ds_list_add(own_key, recvkey);
                ds_list_add(own_ip, recvip);
                ds_list_add(own_port, recvgameport);
                ds_list_add(own_name, recvname);
                ds_list_add(own_req, 0);
                show_debug_message("New server added at: "+recvip+"   called: "+recvname);
            }
        }
        break;
    case MSG_LANREQUEST:
        ///SERVER
        var lantransfer_key, lantransfer_ip, lantransfer_port, lantransfer_name;
        lantransfer_key = ds_list_create();
        ds_list_copy(lantransfer_key, lan_key);
        lantransfer_ip = ds_list_create();
        ds_list_copy(lantransfer_ip, lan_ip);
        lantransfer_port = ds_list_create();
        ds_list_copy(lantransfer_port, lan_port);
        lantransfer_name = ds_list_create();
        ds_list_copy(lantransfer_name, lan_name);
        ds_list_add(lantransfer_key, global.key);
        ds_list_add(lantransfer_ip, lanip);
        ds_list_add(lantransfer_port, global.port);
        ds_list_add(lantransfer_name, global.name);
        for (var i=0; i<ds_list_size(lantransfer_key); i++) {
            if (ds_list_find_value(lantransfer_key, i)==recvkey) {
                ds_list_delete(lantransfer_key, i);
                ds_list_delete(lantransfer_ip, i);
                ds_list_delete(lantransfer_port, i);
                ds_list_delete(lantransfer_name, i);
                break;
            }
        }
        ds_list_clear(datalist);
        ds_list_add(datalist, ds_list_write(lantransfer_key));
        ds_list_add(datalist, ds_list_write(lantransfer_ip));
        ds_list_add(datalist, ds_list_write(lantransfer_port));
        ds_list_add(datalist, ds_list_write(lantransfer_name));
        if (ds_list_find_index(netsockets_id, recvid)==-1) {
            net_push(NET_UDP, recvip, recvport, MSG_LANTRANSFER, datalist, udpport, global.key);
        } else {
            net_send(recvid, MSG_LANTRANSFER, datalist, udpport, global.key);
        }
        break;
        
    case MSG_LANTRANSFER:
        ///CLIENT
        ds_list_read(lan_key, ds_list_find_value(recvlist, 0));
        ds_list_read(lan_ip, ds_list_find_value(recvlist, 1));
        ds_list_read(lan_port, ds_list_find_value(recvlist, 2));
        ds_list_read(lan_name, ds_list_find_value(recvlist, 3));
        break;
}
