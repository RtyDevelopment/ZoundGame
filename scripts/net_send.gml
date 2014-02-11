///net_send(key,msgtype,datalist)
globalvar net_peer_key, net_peer_ip, net_peer_port, net_peer_nettype, net_peer_name, net_peer_ping, net_peer_lastping, net_peer_pingrecv, net_peer_type, net_peer_socket;
globalvar net_key, net_name;
var destkey, msgtype, datalist;
var conntype, url, port, socket, buffer, str_;

destkey = argument0;
pos = ds_list_find_index(net_peer_key, destkey);
if (pos<0) return -1;

conntype = ds_list_find_value(net_peer_nettype, pos);
url = ds_list_find_value(net_peer_ip, pos);
port = ds_list_find_value(net_peer_port, pos);
socket = ds_list_find_value(net_peer_socket, pos);
msgtype = argument1;
datalist = argument2;

switch (conntype) {
    case NET_BROADCAST:
    case NET_UDP:
    case NET_TCP:
    case NET_TCPRAW:
        buffer = buffer_create(1, buffer_grow, 1);
        buffer_seek(buffer, buffer_seek_start, 0);
        buffer_write(buffer, buffer_string, "[OPENP2PNET][v0.1.0.0]");
        buffer_write(buffer, buffer_string, string(msgtype));
        buffer_write(buffer, buffer_string, string(conntype));
        buffer_write(buffer, buffer_string, net_key);
        buffer_write(buffer, buffer_string, net_name);
        buffer_write(buffer, buffer_string, destkey);
        for (var i=0; i<ds_list_size(datalist); i++) {
            buffer_write(buffer, buffer_string, string(ds_list_find_value(datalist, i)));
        }
        break;
    case NET_HTTP:
        str_ = url+"?openptpnet=v0/1/0/0";
        str_ += "&conntype="+string(conntype);
        str_ += "&msgtype="+string(msgtype);
        str_ += "&key="+net_key;
        str_ += "&name="+net_name;
        str_ += "&destkey="+destkey;
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
    case NET_TCPRAW:
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
    case NET_TCPRAW:
        buffer_delete(buffer);
        break;
    case NET_HTTP:
        break;
}
