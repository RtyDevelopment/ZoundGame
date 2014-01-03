///get_decimals(real)
var int, check, decloc;
int = string(argument0);
check = true;
while (check==true) {
    if (string_char_at(int, string_length(int))=="0") int = string_delete(int, string_length(int), 1); else check = false;
}
decloc = string_pos(".", int);
if (decloc==0) return 0;
return string_length(int)-decloc;
