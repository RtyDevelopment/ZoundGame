///net_send(id,msgtype,datalist)
globalvar net_key, net_pubport, net_sockets, net_sockets_id, net_sockets_ip, net_sockets_type, net_sockets_port;
var _id, msgtype, datalist;
var conntype, url, port, socket, buffer, str_;

_id = argument0;
pos = ds_list_find_index(net_sockets_id, _id);
if (pos<0) return -1;

conntype = ds_list_find_value(net_sockets_type, pos);
url = ds_list_find_value(net_sockets_ip, pos);
port = ds_list_find_value(net_sockets_port, pos);
socket = ds_list_find_value(net_sockets, pos);
msgtype = argument1;
datalist = argument2;

switch (conntype) {
    case NET_BROADCAST:
    case NET_UDP:
    case NET_TCP:
        buffer = buffer_create(1, buffer_grow, 1);
        buffer_seek(buffer, buffer_seek_start, 0);
        buffer_write(buffer, buffer_u8, conntype);
        buffer_write(buffer, buffer_string, _id);
        buffer_write(buffer, buffer_s8, msgtype);
        buffer_write(buffer, buffer_u16, net_pubport);
        buffer_write(buffer, buffer_u8, net_pubtype);
        buffer_write(buffer, buffer_u16, net_lanport);
        buffer_write(buffer, buffer_string, net_key);
        for (var i=0; i<ds_list_size(datalist); i++) {
            buffer_write(buffer, buffer_string, string(ds_list_find_value(datalist, i)));
        }
        break;
    case NET_HTTP:
        str_ = url+"?type="+string(conntype)+"&id="+_id+"&timer="+string(get_timer())+"&msg="+string(msgtype)+"&pubport="+string(net_pubport)+"&pubtype="+string(net_pubport)+"&lanport="+string(net_lanport)+"&key="+net_key;
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
