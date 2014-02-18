///net_init(name,key,port,connectiontype,interval);
globalvar net_name, net_key, net_lanport, net_pubport, net_pubtype, net_interval;
globalvar net_peer_id, net_peer_key, net_peer_ip, net_peer_port, net_peer_nettype, net_peer_name, net_peer_ping, net_peer_lastping, net_peer_pingrecv, net_peer_type, net_peer_socket;
globalvar net_cmdlist, net_msglist, net_idcounter;
globalvar net_devicemaster, net_devicemasterid, net_lanserver, net_pubserver, net_timer;

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

//Recieved message hashes
net_msglist = ds_list_create();

//LAN
net_devicemaster = true;
net_devicemasterid = -1;
net_lanserver = network_create_server(network_socket_udp, net_lanport, 32);
if (net_lanserver<0) {
    while (net_devicemasterid<0) net_devicemasterid = net_connect(NET_UDP, "127.0.0.1", 6510);
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

/*
var file;
file = file_text_open_write(working_directory+"\export.txt");
file_text_write_string(file, " # VARS # ");
file_text_writeln(file);
file_text_write_string(file, "Time started: "+get_time_string());
file_text_writeln(file);
file_text_write_string(file, "DevMaster   : "+string(net_devicemaster));
file_text_writeln(file);
file_text_write_string(file, "LAN port    : "+string(net_lanport));
file_text_writeln(file);
file_text_write_string(file, "Public port : "+string(net_pubport));
file_text_writeln(file);
file_text_write_string(file, "Public type : "+string(net_pubtype));
file_text_writeln(file);
file_text_write_string(file, "Name        : "+net_name);
file_text_writeln(file);
file_text_write_string(file, "Key         : "+sha1_string_unicode(net_key));
file_text_writeln(file);
file_text_write_string(file, " # PACKAGES # ");
file_text_writeln(file);
file_text_close(file);
//*/
