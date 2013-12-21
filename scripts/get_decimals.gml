var _str, check, decloc;
_str = string(argument0);
check = true;
while (check==true) {
    if (string_char_at(_str, string_length(_str))=="0") _str = string_delete(_str, string_length(_str), 1); else check = false;
}
decloc = string_pos(".", _str);
if (decloc==0) return 0;
return string_length(_str)-decloc;
