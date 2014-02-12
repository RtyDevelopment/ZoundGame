///net_receive(eventtype,ds_list,ip,port,socket)
/******************
** RETURN VALUES **
*******************
**   1: Message correctly handled
**   0: Error
**  -1: Unknown protocol
**  -2: OPENP2PNET implementation is outdated
** any: Unknown OPENP2PNET Message, return value is message type
*/
globalvar net_key, net_name;
globalvar net_peer_key, net_peer_ip, net_peer_port, net_peer_nettype, net_peer_name, net_peer_ping, net_peer_lastping, net_peer_pingrecv, net_peer_type, net_peer_socket;
globalvar net_keycounter;
var recvlist, recvip, recvport, recvsocket, recvmsg, recvtype, recvkey, recvtokey, datalist, datastart;

recvlist = argument1;
recvip = argument2;
recvport = argument3;
recvsocket = argument4;

if (argument0!=network_type_data) {
    if (argument0==network_type_connect) {
        net_keycounter++;
        ds_list_add(net_peer_key, "?"+string(net_keycounter));
        ds_list_add(net_peer_ip, recvip);
        ds_list_add(net_peer_port, recvport);
        ds_list_add(net_peer_nettype, NET_TCP); //Since you can't run a raw server, and all other protocols are connectionless, it must be built-in TCP
        ds_list_add(net_peer_name, "?");
        ds_list_add(net_peer_ping, 0);
        ds_list_add(net_peer_lastping, 0);
        ds_list_add(net_peer_pingrecv, 0);
        ds_list_add(net_peer_type, NETTYPE_PEER);
        ds_list_add(net_peer_socket, recvsocket);
    } else {
        pos = ds_list_find_index(net_peer_socket, recvsocket);
        ds_list_delete(net_peer_key, pos);
        ds_list_delete(net_peer_ip, pos);
        ds_list_delete(net_peer_port, pos);
        ds_list_delete(net_peer_nettype, pos);
        ds_list_delete(net_peer_name, pos);
        ds_list_delete(net_peer_ping, pos);
        ds_list_delete(net_peer_lastping, pos);
        ds_list_delete(net_peer_pingrecv, pos);
        ds_list_delete(net_peer_type, pos);
        ds_list_delete(net_peer_socket, pos);
    }
    return 1;
}

if (string_copy(ds_list_find_value(recvlist, 0), 1, 12)!="[OPENP2PNET]") return -1;
if (string_delete(ds_list_find_value(recvlist, 0), 1, 12)!="[v0.1.0.0]") return -2;
recvmsg = real(ds_list_find_value(recvlist, 1));
recvtype = real(ds_list_find_value(recvlist, 2));
recvkey = ds_list_find_value(recvlist, 3);
recvname = ds_list_find_value(recvlist, 4);
recvtokey = ds_list_find_value(recvlist, 5);
datastart = 6;

if (recvtype==NET_TCP || recvtype==NET_TCPRAW) {
    var peerpos = ds_list_find_index(net_peer_socket, recvsocket);
    if (peerpos>=0) {
        if (string_copy(ds_list_find_value(net_peer_key, peerpos), 1, 1)=="?") ds_list_replace(net_peer_key, peerpos, recvkey);
        if (ds_list_find_value(net_peer_name, peerpos)=="?") ds_list_replace(net_peer_name, peerpos, recvname);
    }
} else {
    var peerpos = ds_list_find_index(net_peer_key, recvkey);
    if (peerpos<0) {
        ds_list_add(net_peer_key, recvkey);
        ds_list_add(net_peer_ip, recvip);
        ds_list_add(net_peer_port, recvport);
        ds_list_add(net_peer_nettype, recvtype);
        ds_list_add(net_peer_name, recvname);
        ds_list_add(net_peer_ping, 0);
        ds_list_add(net_peer_lastping, 0);
        ds_list_add(net_peer_pingrecv, 0);
        if (recvtype==NET_BROADCAST) {
            ds_list_add(net_peer_type, NETTYPE_LAN);
        } else {
            ds_list_add(net_peer_type, NETTYPE_PEER);
        }
        switch (recvtype) {
            case NET_BROADCAST:
            case NET_UDP:
                socket = -1;
                while (socket<0) socket = network_create_socket(network_socket_udp);
                ds_list_add(net_peer_socket, socket);
                break;
            case NET_HTTP:
                ds_list_add(net_peer_socket, -1);
        }
    } else {
        if (ds_list_find_value(net_peer_name, peerpos)=="?") ds_list_replace(net_peer_name, peerpos, recvname);
    }
}

if (recvtokey!=net_key) {
    var fwdlist = ds_list_create();
    ds_list_copy(fwdlist, recvlist);
    ds_list_insert(fwdlist, 0, recvip);
    ds_list_insert(fwdlist, 1, recvport);
    if (ds_list_find_index(net_peer_key, recvtokey)==-1) {
        for (var i=0; i<ds_list_size(net_peer_key); i++) {
            net_send(ds_list_find_value(net_peer_key, i), MSG_FORWARD, fwdlist);
        }
    } else {
        net_send(recvtokey, recvmsg, recvlist);
    }
    ds_list_destroy(fwdlist);
    return 1;
}

switch (recvmsg) {
    case MSG_CONN:
        ///SERVER
        return 1;
        
    case MSG_DISCONN:
        ///SERVER
        net_disconnect(recvkey);
        return 1;
    
    case MSG_FORWARD:
        var fwdip, fwdport, fwdlist, fwdrecv;
        fwdip = ds_list_find_value(recvlist, datastart);
        fwdport = real(ds_list_find_value(recvlist, datastart+1));
        fwdlist = ds_list_create();
        ds_list_copy(fwdlist, recvlist);
        repeat (datastart+2) ds_list_delete(fwdlist, 0);
        fwdrecv = net_receive(network_type_data, fwdlist, fwdip, fwdport, recvsocket);
        ds_list_destroy(fwdlist);
        return fwdrecv;
        
    case MSG_PING:
        ///SERVER
        datalist = ds_list_create();
        ds_list_add(datalist, ds_list_find_value(recvlist, datastart));
        net_send(recvkey, MSG_PONG, datalist);
        ds_list_destroy(datalist);
        return 1;
        
    case MSG_PONG:
        ///CLIENT
        pos = ds_list_find_index(net_peer_key, recvkey);
        ds_list_replace(net_peer_ping, pos, round((get_timer()-real(ds_list_find_value(recvlist, datastart)))/1000));
        return 1;
        
    case MSG_INFOREQUEST:
        ///SERVER
        datalist = ds_list_create();
        net_send(recvkey, MSG_INFO, datalist);
        ds_list_destroy(datalist);
        return 1;
        
    case MSG_INFO:
        ///CLIENT
        ds_list_replace(net_peer_type, ds_list_find_index(net_peer_key, recvkey), NETTYPE_EXT);
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
        lantransfer_type = ds_list_create();
        ds_list_copy(lantransfer_type, net_lan_nettype);
        lantransfer_name = ds_list_create();
        ds_list_copy(lantransfer_name, net_lan_name);
        datalist = ds_list_create();
        ds_list_add(lantransfer_key, net_key);
        ds_list_add(lantransfer_ip, "127.0.0.1");
        ds_list_add(lantransfer_port, net_lanport);
        ds_list_add(lantransfer_type, network_socket_udp);
        ds_list_add(lantransfer_name, net_name);
        ds_list_add(datalist, ds_list_write(lantransfer_key));
        ds_list_add(datalist, ds_list_write(lantransfer_ip));
        ds_list_add(datalist, ds_list_write(lantransfer_port));
        ds_list_add(datalist, ds_list_write(lantransfer_type));
        ds_list_add(datalist, ds_list_write(lantransfer_name));
        if (ds_list_find_index(net_sockets_id, recvid)==-1) {
            net_push(NET_UDP, recvip, recvlanport, MSG_LANTRANSFER, datalist);
        } else {
            net_send(recvid, MSG_LANTRANSFER, datalist);
        }
        ds_list_destroy(datalist);
        ds_list_destroy(lantransfer_key);
        ds_list_destroy(lantransfer_ip);
        ds_list_destroy(lantransfer_port);
        ds_list_destroy(lantransfer_type);
        ds_list_destroy(lantransfer_name);
        return 1;
        
    case MSG_LANTRANSFER:
        ///CLIENT
        var lantransfer_key, lantransfer_ip, lantransfer_port, lantransfer_name;
        lantransfer_key = ds_list_create();
        lantransfer_ip = ds_list_create();
        lantransfer_port = ds_list_create();
        lantransfer_type = ds_list_create();
        lantransfer_name = ds_list_create();
        
        ds_list_read(lantransfer_key, ds_list_find_value(recvlist, datastart));
        ds_list_read(lantransfer_ip, ds_list_find_value(recvlist, datastart+1));
        ds_list_read(lantransfer_port, ds_list_find_value(recvlist, datastart+2));
        ds_list_read(lantransfer_type, ds_list_find_value(recvlist, datastart+3));
        ds_list_read(lantransfer_name, ds_list_find_value(recvlist, datastart+4));
        
        pos = ds_list_find_index(lantransfer_key, net_key);
        if (pos!=-1) {
            ds_list_delete(lantransfer_key, pos);
            ds_list_delete(lantransfer_ip, pos);
            ds_list_delete(lantransfer_port, pos);
            ds_list_delete(lantransfer_type, pos);
            ds_list_delete(lantransfer_name, pos);
        }
        
        for (var i=0; i<ds_list_size(lantransfer_key); i++) {
            if (ds_list_find_index(net_lan_key, ds_list_find_value(lantransfer_key, i))==-1) {
                ds_list_add(net_lan_key, ds_list_find_value(lantransfer_key, i));
                ds_list_add(net_lan_ip, ds_list_find_value(lantransfer_ip, i));
                ds_list_add(net_lan_port, ds_list_find_value(lantransfer_port, i));
                ds_list_add(net_lan_nettype, ds_list_find_value(lantransfer_type, i));
                ds_list_add(net_lan_name, ds_list_find_value(lantransfer_name, i));
                ds_list_add(net_lan_req, 0);
                ds_list_add(net_lan_ping, 0);
                ds_list_add(net_lan_lastping, 0);
                
                show_debug_message("Added '"+ds_list_find_value(lantransfer_name, i)+"' on "+ds_list_find_value(lantransfer_ip, i)+":"+string(ds_list_find_value(lantransfer_port, i)));
            }
        }
        
        ds_list_destroy(lantransfer_key);
        ds_list_destroy(lantransfer_ip);
        ds_list_destroy(lantransfer_port);
        ds_list_destroy(lantransfer_type);
        ds_list_destroy(lantransfer_name);
        return 1;
        
    default:
        return recvmsg;
}
