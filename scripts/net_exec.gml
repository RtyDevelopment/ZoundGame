///netcommand(command,argument0,argument1,etc.)
if (argument_count>=1) {
    ds_list_add(obj_network.netcommands, argument[0]);
    if (argument_count>=2) ds_list_add(obj_network.netcommands_arg0, argument[1]); else ds_list_add(obj_network.netcommands_arg0, "");
    if (argument_count>=3) ds_list_add(obj_network.netcommands_arg1, argument[2]); else ds_list_add(obj_network.netcommands_arg1, "");
    if (argument_count>=4) ds_list_add(obj_network.netcommands_arg2, argument[3]); else ds_list_add(obj_network.netcommands_arg2, "");
    if (argument_count>=5) ds_list_add(obj_network.netcommands_arg3, argument[4]); else ds_list_add(obj_network.netcommands_arg3, "");
    if (argument_count>=6) ds_list_add(obj_network.netcommands_arg4, argument[5]); else ds_list_add(obj_network.netcommands_arg4, "");
}
