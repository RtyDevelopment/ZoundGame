///net_push(conntype,url,port,msgtype,datalist)
globalvar net_sockets, net_sockets_id, net_sockets_ip, net_sockets_port, net_sockets_type, net_sockets_acc;
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
            socket = network_create_socket(network_socket_tcp);
            network_connect(socket, url, port);
            break;
        case NET_HTTP:
            socket = 0;
            break;
    }
}
ds_list_add(net_sockets, socket);
ds_list_add(net_sockets_id, "-1");
ds_list_add(net_sockets_ip, url);
ds_list_add(net_sockets_port, port);
ds_list_add(net_sockets_type, conntype);
ds_list_add(net_sockets_acc, false);

net_send("-1", argument3, argument4);

switch (argument0) {
    case NET_BROADCAST:
    case NET_UDP:
    case NET_TCP:
        network_destroy(socket);
        break;
    case NET_HTTP:
        break;
}
net_disconnect("-1");
