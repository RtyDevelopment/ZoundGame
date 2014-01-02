///string_set_at(str,pos,chr);
var chrlist, retstr;
if (argument1>string_length(argument0)) return argument0;
for (var i=0; i<string_length(string(argument0)); i++) chrlist[i] = string_char_at(string(argument0), i+1);
chrlist[argument1-1] = string_char_at(string(argument2), 1);
retstr = "";
for (var i=0; i<array_length_1d(chrlist); i++) retstr += chrlist[i];
return retstr;
