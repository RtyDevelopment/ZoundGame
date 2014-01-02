//draw_line_glow(x1,y1,x2,y2,w,r);
var i, alpha, dir, x1, y1, x2, y2;
dir = point_direction(argument2,argument3,argument0,argument1);
alpha = draw_get_alpha();
x1 = argument0+lengthdir_x(argument5, dir);
y1 = argument1+lengthdir_y(argument5, dir);
x2 = argument2-lengthdir_x(argument5, dir);
y2 = argument3-lengthdir_y(argument5, dir);
draw_set_alpha(1/argument5*alpha);
for (i=argument5; i>0; i-=1) {
    draw_line_width(x1+lengthdir_x(i-argument5, dir),y1+lengthdir_y(i-argument5, dir),x2-lengthdir_x(i-argument5, dir),y2-lengthdir_y(i-argument5, dir),i*2);
}
draw_set_alpha(alpha);
draw_line_width(argument0+lengthdir_x(argument4/2, dir), argument1+lengthdir_y(argument4/2, dir), argument2-lengthdir_x(argument4/2, dir), argument3-lengthdir_y(argument4/2, dir), argument4);
