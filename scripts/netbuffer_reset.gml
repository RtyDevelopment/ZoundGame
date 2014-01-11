///netbuffer_reset(buffer,msgtype,replyport,key)
buffer_resize(argument0, 1);
buffer_seek(argument0, buffer_seek_start, 0);
buffer_write(argument0, buffer_u8, argument1);
buffer_write(argument0, buffer_u16, argument2);
buffer_write(argument0, buffer_string, argument3);
