globalvar net_name, net_pubport, net_landevicemaster, net_interval, net_timer;
globalvar net_own_key, net_own_ip, net_own_port, net_own_type, net_own_name, net_own_req, net_own_ping, net_own_lastping;
globalvar net_lan_key, net_lan_ip, net_lan_port, net_lan_type, net_lan_name, net_lan_req, net_lan_ping, net_lan_lastping;
var outputlist = ds_list_create();

if (net_timer==0) {
    ds_list_clear(outputlist);
    ds_list_add(outputlist, 1);
    ds_list_add(outputlist, net_name);
    net_push(NET_BROADCAST, -1, 6510, MSG_INFO, outputlist);
    if (net_devicemaster==false) {
        ds_list_clear(outputlist);
        net_push(NET_UDP, "127.0.0.1", 6510, MSG_LANREQUEST, outputlist);
    }
    net_timer = net_interval;
}
net_timer--;
for (var i=0; i<ds_list_size(net_own_lastping); i++) {
    if (get_timer()-ds_list_find_value(net_own_lastping, i)>net_interval/room_speed*1000000 || ds_list_find_value(net_lan_ping, i)==0) {
        ds_list_clear(outputlist);
        ds_list_add(outputlist, get_timer());
        var type = ds_list_find_value(net_own_type, i);
        var ip = ds_list_find_value(net_own_ip, i);
        var port = ds_list_find_value(net_own_port, i);
        net_push(type, ip, port, MSG_PING, outputlist);
        ds_list_replace(net_own_lastping, i, get_timer());
    }
}
for (var i=0; i<ds_list_size(net_lan_lastping); i++) {
    if (get_timer()-ds_list_find_value(net_lan_lastping, i)>net_interval/room_speed*1000000 || ds_list_find_value(net_lan_ping, i)==0) {
        ds_list_clear(outputlist);
        ds_list_add(outputlist, get_timer());
        var type = ds_list_find_value(net_lan_type, i);
        var ip = ds_list_find_value(net_lan_ip, i);
        var port = ds_list_find_value(net_lan_port, i);
        net_push(type, ip, port, MSG_PING, outputlist);
        ds_list_replace(net_lan_lastping, i, get_timer());
    }
}
ds_list_destroy(outputlist);
/*
if (ds_list_size(netcommands)>0) {
    repeat (ds_list_size(netcommands)) {
        switch (ds_list_find_value(netcommands, 0)) {
            case MSG_PING:
                
                break;
            case MSG_INFOREQUEST:
                
                break;
        }
        ds_list_delete(netcommands, 0);
        ds_list_delete(netcommands_arg0, 0);
    }
}*/

