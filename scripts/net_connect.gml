///net_connect(conntype,url,port,key);
var socket, conntype, url, port, key, _id;
socket = -1;
conntype = argument0;
url = argument1;
port = argument2;
key = argument3;
_id = sha1_string_unicode(string(get_timer())+key);
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
        net_send(_id, MSG_CONN, buffer, udpport, global.key);
        ds_list_destroy(buffer);
        break;
    case NET_BROADCAST:
    case NET_HTTP:
        break;
}

return _id;
