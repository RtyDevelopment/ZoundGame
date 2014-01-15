globalvar net_name, net_pubport, net_landevicemaster, net_timer;
var outputlist;

if (net_timer==0) {
    outputlist = ds_list_create();
    ds_list_add(outputlist, 1);
    ds_list_add(outputlist, net_name);
    net_push(NET_BROADCAST, -1, 6510, MSG_INFO, outputlist);
    if (net_landevicemaster==false) {
        ds_list_clear(outputlist);
        net_push(NET_UDP, "127.0.0.1", 6510, MSG_LANREQUEST, outputlist);
    }
    ds_list_destroy(outputlist);
    net_timer = net_interval;
}
net_timer--;
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

