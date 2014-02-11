///net_push(conntype,url,port,msgtype,datalist)
//globalvar net_sockets, net_sockets_id, net_sockets_ip, net_sockets_port, net_sockets_type, net_sockets_acc;
globalvar net_peer_key, net_peer_ip, net_peer_port, net_peer_nettype, net_peer_name, net_peer_ping, net_peer_lastping, net_peer_pingrecv, net_peer_type, net_peer_socket;
var socket, conntype, url, port;
socket = -1;
conntype = argument0;
url = argument1;
port = argument2;
while (socket<0) {
    switch (argument0) {
        case NET_BROADCAST:
        case NET_UDP:
            socket = network_create_socket(network_socket_udp);
            break;
        case NET_TCP:
        case NET_TCPRAW:
            socket = network_create_socket(network_socket_tcp);
            break;
        case NET_HTTP:
            socket = 0;
            break;
    }
}
if (argument0==NET_TCP || argument0==NET_TCPRAW) {
    var conn, i;
    conn = -1;
    i = 0;
    while (conn<-1) {
        if (argument0==NET_TCP) {
            if (i>=5) return -1;
            conn = network_connect(socket, url, port);
        } else {
            conn = network_connect_raw(socket, url, port);
        }
        i++;
    }
}
ds_list_add(net_peer_key, "-1");
ds_list_add(net_peer_ip, url);
ds_list_add(net_peer_port, port);
ds_list_add(net_peer_nettype, conntype);
ds_list_add(net_peer_name, "?");
ds_list_add(net_peer_ping, 0);
ds_list_add(net_peer_lastping, 0);
ds_list_add(net_peer_pingrecv, 0);
ds_list_add(net_peer_type, NETTYPE_PEER);
ds_list_add(net_peer_socket, socket);

net_send("-1", argument3, argument4);

net_disconnect("-1");
