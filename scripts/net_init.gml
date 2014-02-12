///net_init(name,key,port,connectiontype,interval);
globalvar net_name, net_key, net_lanport, net_pubport, net_pubtype, net_interval;
globalvar net_peer_id, net_peer_key, net_peer_ip, net_peer_port, net_peer_nettype, net_peer_name, net_peer_ping, net_peer_lastping, net_peer_pingrecv, net_peer_type, net_peer_socket;
globalvar net_cmdlist, net_idcounter;
globalvar net_devicemaster, net_lanserver, net_pubserver, net_timer;

net_name = argument0;
net_key = argument1;
net_lanport = 6510;
net_pubport = argument2;
net_pubtype = argument3;
net_interval = argument4;

//Serverlists
net_peer_id = ds_list_create();         //Local ID of the clien
net_peer_key = ds_list_create();        //Key: unique ID of the client
net_peer_ip = ds_list_create();         //IP
net_peer_port = ds_list_create();       //Port
net_peer_nettype = ds_list_create();    //Nettype: type of connection (NET_*: UDP, TCP, BROADCAST, HTTP)
net_peer_name = ds_list_create();       //Name: Human-readable ID of the client
net_peer_ping = ds_list_create();       //Last ping time: time to receive an answer of an "empty" package
net_peer_lastping = ds_list_create();   //Last time a ping was sent
net_peer_pingrecv = ds_list_create();   //Last time a ping answer was received
net_peer_type = ds_list_create();       //Type of connection (NETTYPE_*: LAN, EXT, PEER)
net_peer_socket = ds_list_create();     //Socket ID of the connection

net_idcounter = 0;

//Commands
net_cmdlist = ds_list_create();

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
