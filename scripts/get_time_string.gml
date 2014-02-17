///get_time_string
var str_;
str_ = string_format(current_year, 4, 0)+string_format(current_month, 2, 0)+string_format(current_day, 2, 0)+string_format(current_hour, 2, 0)+string_format(current_minute, 2, 0)+string_format(current_second, 2, 0);
return string_replace_all(str_, " ", "0");
