///net_push(conntype,url,port,msgtype,datalist,localcommport,localkey)
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
            network_connect(socket, argument1, argument2);
            break;
        case NET_HTTP:
            socket = 0;
            break;
    }
}
ds_list_add(netsockets, socket);
ds_list_add(netsockets_id, "-1");
ds_list_add(netsockets_ip, url);
ds_list_add(netsockets_port, port);
ds_list_add(netsockets_type, conntype);
ds_list_add(netsockets_acc, false);

net_send("-1", argument3, argument4, argument5, argument6);

switch (argument0) {
    case NET_BROADCAST:
    case NET_UDP:
    case NET_TCP:
        network_destroy(socket);
        break;
    case NET_HTTP:
        break;
}
pos = ds_list_find_index(netsockets_id, "-1");
ds_list_delete(netsockets, pos);
ds_list_delete(netsockets_id, pos);
ds_list_delete(netsockets_ip, pos);
ds_list_delete(netsockets_port, pos);
ds_list_delete(netsockets_type, pos);
ds_list_delete(netsockets_acc, pos);
