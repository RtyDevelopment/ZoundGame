///net_receive(eventtype,ds_list)
globalvar net_key, net_name, net_sockets, net_sockets_id, net_sockets_ip, net_sockets_port, net_sockets_type, net_sockets_acc;
var recvip, recvlist, recvtype, recvid, recvmsg, recvip, recvpubport, recvkey, datalist;

if (argument0!=network_type_data) {
    if (argument0==network_type_connect) {
        recvip = ds_map_find_value(async_load, "ip");
        if (ds_map_exists(net_sockets_unknown, recvip)==true) {
            network_destroy(ds_map_find_value(net_sockets_unknown, recvip));
            network_destroy(socket);
            ds_map_delete(net_sockets_unknown, recvip);
        } else {
            ds_map_add(net_sockets_unknown, recvip, socket);
        }
    }
    return 1;
}

recvlist = argument1;
recvtype = real(ds_list_find_value(recvlist, 0));
ds_list_delete(recvlist, 0);
recvid = ds_list_find_value(recvlist, 0);
ds_list_delete(recvlist, 0);
recvmsg = real(ds_list_find_value(recvlist, 0));
ds_list_delete(recvlist, 0);
recvpubport = real(ds_list_find_value(recvlist, 0));
ds_list_delete(recvlist, 0);
recvlanport = real(ds_list_find_value(recvlist, 0));
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
        if (ds_map_exists(net_sockets_unknown, recvip)==true) {
            var socket = ds_map_find_value(net_sockets_unknown, recvip);
            ds_map_delete(net_sockets_unknown, recvip);
        } else {
            switch (recvtype) {
                case NET_BROADCAST:
                case NET_UDP:
                    var socket = network_create_socket(network_socket_udp);
                    break;
                case NET_TCP:
                    return -1;
                case NET_HTTP:
                    var socket = -1;
                    break;
            }
        }
        ds_list_add(net_sockets, socket);
        ds_list_add(net_sockets_id, recvid);
        ds_list_add(net_sockets_ip, recvip);
        ds_list_add(net_sockets_port, recvpubport);
        ds_list_add(net_sockets_type, recvtype);
        ds_list_add(net_sockets_acc, true);
        return 1;
        
    case MSG_CONNACCEPT:
        ///CLIENT
        pos = ds_list_find_index(net_sockets_id, recvid);
        if (pos<0) return -1;
        ds_list_replace(net_sockets_acc, pos, true);
        return 1;
        
    case MSG_DISCONN:
        ///SERVER
        var pos = ds_list_find_index(net_sockets_id, recvid);
        if (pos<0) break;
        
        switch (recvtype) {
            case NET_BROADCAST:
            case NET_UDP:
            case NET_TCP:
                var socket, buffer;
                socket = ds_list_find_value(net_sockets, pos);
                network_destroy(socket);
                break;
            case NET_HTTP:
                break;
        }
        ds_list_delete(net_sockets, pos);
        ds_list_delete(net_sockets_id, pos);
        ds_list_delete(net_sockets_ip, pos);
        ds_list_delete(net_sockets_port, pos);
        ds_list_delete(net_sockets_type, pos);
        ds_list_delete(net_sockets_acc, pos);
        return 1;
        
    case MSG_PING:
        ///SERVER
        datalist = ds_list_create();
        if (ds_list_find_index(net_sockets_id, recvid)==-1) {
            net_push(NET_UDP, recvip, recvpubport, MSG_PONG, datalist);
        } else {
            net_send(recvid, MSG_PONG, datalist);
        }
        ds_list_destroy(datalist);
        return 1;
        
    case MSG_PONG:
        ///CLIENT
        //pass
        return 1;
        
    case MSG_INFOREQUEST:
        ///SERVER
        datalist = ds_list_create();
        ds_list_add(datalist, 0);
        ds_list_add(datalist, net_name);
        if (ds_list_find_index(net_sockets_id, recvid)==-1) {
            net_push(NET_UDP, recvip, recvpubport, MSG_INFO, datalist);
        } else {
            net_send(recvid, MSG_INFO, datalist);
        }
        ds_list_destroy(datalist);
        return 1;
        
    case MSG_INFO:
        ///CLIENT
        var recvlan = real(ds_list_find_value(recvlist, 0));
        var recvname = ds_list_find_value(recvlist, 1);
        if (recvlan==true) {
            if (ds_list_find_index(net_lan_key, recvkey)<0 && net_key!=recvkey) {
                ds_list_add(net_lan_key, recvkey);
                ds_list_add(net_lan_ip, recvip);
                ds_list_add(net_lan_port, recvpubport);
                ds_list_add(net_lan_name, recvname);
                ds_list_add(net_lan_req, 0);
                show_debug_message("New server found at: "+recvip+"   called: "+recvname);
            }
        } else {
            if (ds_list_find_index(net_own_key, recvkey)<0 && net_key!=recvkey) {
                ds_list_add(net_own_key, recvkey);
                ds_list_add(net_own_ip, recvip);
                ds_list_add(net_own_port, recvpubport);
                ds_list_add(net_own_name, recvname);
                ds_list_add(net_own_req, 0);
                show_debug_message("New server added at: "+recvip+"   called: "+recvname);
            }
        }
        return 1;
        
    case MSG_LANREQUEST:
        ///SERVER
        var lantransfer_key, lantransfer_ip, lantransfer_port, lantransfer_name;
        lantransfer_key = ds_list_create();
        ds_list_copy(lantransfer_key, net_lan_key);
        lantransfer_ip = ds_list_create();
        ds_list_copy(lantransfer_ip, net_lan_ip);
        lantransfer_port = ds_list_create();
        ds_list_copy(lantransfer_port, net_lan_port);
        lantransfer_name = ds_list_create();
        ds_list_copy(lantransfer_name, net_lan_name);
        datalist = ds_list_create();
        ds_list_add(datalist, net_name);
        ds_list_add(datalist, ds_list_write(lantransfer_key));
        ds_list_add(datalist, ds_list_write(lantransfer_ip));
        ds_list_add(datalist, ds_list_write(lantransfer_port));
        ds_list_add(datalist, ds_list_write(lantransfer_name));
        if (ds_list_find_index(net_sockets_id, recvid)==-1) {
            net_push(NET_UDP, recvip, recvlanport, MSG_LANTRANSFER, datalist);
        } else {
            net_send(recvid, MSG_LANTRANSFER, datalist);
        }
        ds_list_destroy(datalist);
        return 1;
        
    case MSG_LANTRANSFER:
        ///CLIENT
        ds_list_read(net_lan_key, ds_list_find_value(recvlist, 1));
        ds_list_read(net_lan_ip, ds_list_find_value(recvlist, 2));
        ds_list_read(net_lan_port, ds_list_find_value(recvlist, 3));
        ds_list_read(net_lan_name, ds_list_find_value(recvlist, 4));
        
        pos = ds_list_find_index(net_lan_key, net_key);
        if (pos!=-1) {
            ds_list_delete(net_lan_key, pos);
            ds_list_delete(net_lan_ip, pos);
            ds_list_delete(net_lan_port, pos);
            ds_list_delete(net_lan_name, pos);
        }
        
        pos = ds_list_find_index(net_lan_key, recvkey);
        if (pos==-1) {
            ds_list_add(net_lan_key, recvkey);
            ds_list_add(net_lan_ip, recvip);
            ds_list_add(net_lan_port, recvpubport);
            ds_list_add(net_lan_name, ds_list_find_value(recvlist, 0));
        }
        return 1;
        
    case MSG_GETIP:
    default:
        return recvmsg;
}
