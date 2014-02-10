///netcommand(command,argument0,argument1,etc.)
/***********************
** AVAILABLE COMMANDS **
************************
**
** CMD_PING; KEY
**
*/
globalvar net_cmds;
if (argument_count>=1) {
    var list;
    list = ds_list_create();
    for (var i=0; i<argument_count; i++) ds_list_add(list, argument[i]);
    ds_list_add(net_cmds, list);
}
