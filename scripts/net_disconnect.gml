///net_disconnect(id);
var _id, pos;
_id = argument0;
pos = ds_list_find_index(netsockets_id, _id);
if (pos<0) return -1;
type = ds_list_find_value(netsockets_type, pos);

switch (type) {
    case NET_BROADCAST:
    case NET_UDP:
    case NET_TCP:
        var socket, buffer;
        socket = ds_list_find_value(netsockets, pos);
        buffer = ds_list_create();
        net_send(_id, MSG_DISCONN, buffer, udpport, global.key);
        ds_list_destroy(buffer);
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
