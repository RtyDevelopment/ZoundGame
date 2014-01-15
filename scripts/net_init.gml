///net_init(name,key,port,connectiontype,interval);
globalvar net_name, net_key, net_lanport, net_pubport, net_pubtype, net_interval;
globalvar net_own_key, net_own_ip, net_own_port, net_own_type, net_own_name, net_own_req, net_own_ping, net_own_lastping;
globalvar net_lan_key, net_lan_ip, net_lan_port, net_lan_type, net_lan_name, net_lan_req, net_lan_ping, net_lan_lastping;
globalvar net_commands, net_commands_arg0, net_commands_arg1, net_commands_arg2, net_commands_arg3, net_commands_arg4;
globalvar net_sockets, net_sockets_id, net_sockets_ip, net_sockets_port, net_sockets_type, net_sockets_acc, net_sockets_unknown;
globalvar net_devicemaster, net_lanserver, net_pubserver, net_timer;

net_name = argument0;
net_key = argument1;
net_lanport = 6510;
net_pubport = argument2;
net_pubtype = argument3;
net_interval = argument4;

//Serverlists
net_own_key = ds_list_create();
net_own_ip = ds_list_create();
net_own_port = ds_list_create();
net_own_type = ds_list_create();
net_own_name = ds_list_create();
net_own_req = ds_list_create();
net_own_ping = ds_list_create();
net_own_lastping = ds_list_create();

net_lan_key = ds_list_create();
net_lan_ip = ds_list_create();
net_lan_port = ds_list_create();
net_lan_type = ds_list_create();
net_lan_name = ds_list_create();
net_lan_req = ds_list_create();
net_lan_ping = ds_list_create();
net_lan_lastping = ds_list_create();

//Commands
net_commands = ds_list_create();
net_commands_arg0 = ds_list_create();
net_commands_arg1 = ds_list_create();
net_commands_arg2 = ds_list_create();
net_commands_arg3 = ds_list_create();
net_commands_arg4 = ds_list_create();

//Connections
net_sockets = ds_list_create();
net_sockets_id = ds_list_create();
net_sockets_ip = ds_list_create();
net_sockets_port = ds_list_create();
net_sockets_type = ds_list_create();
net_sockets_acc = ds_list_create();

//Unset sockets
net_sockets_unknown = ds_map_create();

//LAN
net_devicemaster = true;
net_lanserver = network_create_server(network_socket_udp, net_lanport, 32);
if (net_lanserver<0) {
    net_devicemaster = false;
    while (net_lanserver<0) {
        net_lanport++;
        net_lanserver = network_create_server(network_socket_udp, net_lanport, 32);
    }
} else {
    //Public
    net_pubserver = network_create_server(net_pubtype, net_pubport, 32);
}

net_timer = 0;
