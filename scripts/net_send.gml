///net_send(id,msgtype,datalist,localcommport,localkey)
var _id, msgtype, datalist, localcommport, localkey;
var conntype, url, port, socket, buffer, str_;

_id = argument0;
pos = ds_list_find_index(netsockets_id, _id);
if (pos<0) return -1;

conntype = ds_list_find_value(netsockets_type, pos);
url = ds_list_find_value(netsockets_ip, pos);
port = ds_list_find_value(netsockets_port, pos);
socket = ds_list_find_value(netsockets, pos);
msgtype = argument1;
datalist = argument2;
localcommport = argument3;
localkey = argument4;

switch (conntype) {
    case NET_BROADCAST:
    case NET_UDP:
    case NET_TCP:
        buffer = buffer_create(1, buffer_grow, 1);
        buffer_seek(buffer, buffer_seek_start, 0);
        buffer_write(buffer, buffer_u8, conntype);
        buffer_write(buffer, buffer_string, _id);
        buffer_write(buffer, buffer_u8, msgtype);
        buffer_write(buffer, buffer_u16, localcommport);
        buffer_write(buffer, buffer_string, localkey);
        for (var i=0; i<ds_list_size(datalist); i++) {
            buffer_write(buffer, buffer_string, string(ds_list_find_value(datalist, i)));
        }
        break;
    case NET_HTTP:
        str_ = url+"?type="+string(conntype)+"&id="+_id+"&msg="+string(msgtype)+"&port="+string(localcommport)+"&key="+localkey;
        for (var i=0; i<ds_list_size(datalist); i++) {
            str_ += "&arg"+string(i)+"="+string(ds_list_find_value(datalist, i));
        }
        break;
}

switch (conntype) {
    case NET_BROADCAST:
        network_send_broadcast(socket, port, buffer, buffer_get_size(buffer));
        break;
    case NET_UDP:
        network_send_udp(socket, url, port, buffer, buffer_get_size(buffer));
        break;
    case NET_TCP:
        network_send_packet(socket, buffer, buffer_get_size(buffer));
        break;
    case NET_HTTP:
        http_get(str_);
        break;
}

switch (conntype) {
    case NET_BROADCAST:
    case NET_UDP:
    case NET_TCP:
        buffer_delete(buffer);
        break;
    case NET_HTTP:
        break;
}
