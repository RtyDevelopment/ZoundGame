globalvar net_name, net_pubport, net_landevicemaster, net_interval, net_timer;
globalvar net_peer_id, net_peer_key, net_peer_ip, net_peer_port, net_peer_nettype, net_peer_name, net_peer_ping, net_peer_lastping, net_peer_pingrecv, net_peer_type, net_peer_socket;
globalvar net_cmdlist;
var outputlist = ds_list_create();

if (net_timer==0) {
    ds_list_clear(outputlist);
    ds_list_add(outputlist, 1);
    ds_list_add(outputlist, net_name);
    net_push(NET_BROADCAST, -1, 6510, MSG_INFO, outputlist);
    if (net_devicemaster==false) {
        ds_list_clear(outputlist);
        net_push(NET_UDP, "127.0.0.1", 6510, MSG_PEERREQUEST, outputlist);
    }
    net_timer = net_interval;
}
net_timer--;
for (var i=0; i<ds_list_size(net_peer_lastping); i++) {
    if (get_timer()-ds_list_find_value(net_peer_lastping, i)>net_interval/room_speed*1000000 || ds_list_find_value(net_peer_ping, i)==0) {
        ds_list_clear(outputlist);
        ds_list_add(outputlist, get_timer());
        var _id = ds_list_find_value(net_peer_id, i);
        net_send(_id, MSG_PING, outputlist);
        ds_list_replace(net_peer_lastping, i, get_timer());
    }
}

if (ds_list_size(net_cmdlist)>0) {
    repeat (ds_list_size(net_cmdlist)) {
        var execlist, timer;
        execlist = ds_list_find_value(net_cmdlist, 0);
        timer = ds_list_find_value(execlist, 1);
        if (timer>0) {
            ds_list_replace(execlist, 1, timer-1);
            continue;
        }
        switch (ds_list_find_value(execlist, 0)) {
            case CMD_PING:
                var _id = ds_list_find_value(net_cmdlist, 1);
                if (ds_list_find_index(net_peer_id, _id)<0) break;
                ds_list_clear(outputlist);
                ds_list_add(outputlist, get_timer());
                net_send(_id, MSG_PING, outputlist);
                break;
        }
        ds_list_destroy(execlist);
        ds_list_delete(net_cmdlist, 0);
    }
}

ds_list_destroy(outputlist);
