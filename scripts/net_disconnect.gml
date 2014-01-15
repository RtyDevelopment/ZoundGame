///net_disconnect(id);
globalvar net_sockets, net_sockets_id, net_sockets_ip, net_sockets_port, net_sockets_type, net_sockets_acc;
var _id, pos, type;
_id = argument0;
pos = ds_list_find_index(net_sockets_id, _id);
if (pos<0) return -1;
type = ds_list_find_value(net_sockets_type, pos);

switch (type) {
    case NET_UDP:
    case NET_TCP:
        if (ds_list_find_value(net_sockets_acc, pos)==true) {
            var buffer = ds_list_create();
            net_send(_id, MSG_DISCONN, buffer);
            ds_list_destroy(buffer);
        }
    case NET_BROADCAST:
        var socket = ds_list_find_value(net_sockets, pos);
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
