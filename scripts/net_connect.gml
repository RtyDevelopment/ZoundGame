///net_connect(conntype,url,port,key);
globalvar net_key, net_sockets, net_sockets_id, net_sockets_ip, net_sockets_port, net_sockets_type, net_sockets_acc;
var socket, conntype, url, port, key, _id;
socket = -1;
conntype = argument0;
url = argument1;
port = argument2;
_id = sha1_string_unicode(string(get_timer())+net_key);
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
ds_list_add(netsockets_id, _id);
ds_list_add(netsockets_ip, url);
ds_list_add(netsockets_port, port);
ds_list_add(netsockets_type, conntype);
ds_list_add(netsockets_acc, false);

switch (argument0) {
    case NET_UDP:
    case NET_TCP:
        var buffer = ds_list_create();
        net_send(_id, MSG_CONN, buffer);
        ds_list_destroy(buffer);
        break;
    case NET_BROADCAST:
    case NET_HTTP:
        break;
}

return _id;
