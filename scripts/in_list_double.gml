//in_list_double(x, y, list_x, list_y);
//tests whether two values exist in two lists at the same position, returns -1 when false, or pos when true
for (var i=0; i<ds_list_size(argument2); i++) {
    if (ds_list_find_value(argument2, i)==argument0) {
        if (ds_list_find_value(argument3, i)==argument1) return i;
    }
}
return -1;
