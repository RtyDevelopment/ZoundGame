var _str, decloc;
_str = string(argument0);
decloc = string_pos(".", _str);
if (decloc==0) return 0;
return string_length(_str)-decloc;
