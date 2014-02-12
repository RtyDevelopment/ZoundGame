///net_connect(url,port,socket);
globalvar net_peer_key, net_peer_ip, net_peer_port, net_peer_nettype, net_peer_name, net_peer_ping, net_peer_lastping, net_peer_pingrecv, net_peer_type, net_peer_socket;
globalvar net_keycounter;
var key, socket, conntype, url, port;
net_keycounter++;
key = "?"+string(net_keycounter);
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

if (conntype==NET_TCP || conntype==NET_TCPRAW) {
    var conn, i;
    conn = -1;
    i = 0;
    while (conn<-1) {
        if (conntype==NET_TCP) {
            if (i>=5) return -1;
            conn = network_connect(socket, url, port);
        } else {
            conn = network_connect_raw(socket, url, port);
        }
        i++;
    }
}

ds_list_add(net_peer_key, key);
ds_list_add(net_peer_ip, url);
ds_list_add(net_peer_port, port);
ds_list_add(net_peer_nettype, conntype);
ds_list_add(net_peer_name, "?");
ds_list_add(net_peer_ping, 0);
ds_list_add(net_peer_lastping, 0);
ds_list_add(net_peer_pingrecv, 0);
ds_list_add(net_peer_type, NETTYPE_EXT);
ds_list_add(net_peer_socket, socket);

switch (argument0) {
    case NET_UDP:
        var buffer = ds_list_create();
        net_send(_id, MSG_CONN, buffer);
        ds_list_destroy(buffer);
        break;
    case NET_TCP:
    case NET_TCPRAW:
    case NET_BROADCAST:
    case NET_HTTP:
        break;
}

return key;
