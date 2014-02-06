///d3d_set_projection_euler(x,y,z,yaw,pitch,roll,distance)
var cos_yaw, sin_yaw, cos_pitch, sin_pitch, cos_roll, sin_roll;
globalvar xto, yto, zto, xup, yup, zup, xx, yy, zz;
cos_yaw = cos(degtorad(argument3));
sin_yaw = sin(degtorad(argument3));
cos_pitch = cos(degtorad(argument4));
sin_pitch = sin(degtorad(argument4));
cos_roll = cos(degtorad(argument5));
sin_roll = sin(degtorad(argument5));

xto = cos_yaw*cos_pitch;
yto = -sin_yaw*cos_pitch;
zto = sin_pitch;

xup = sin_yaw*sin_roll - cos_yaw*sin_pitch*cos_roll;
yup = sin_yaw*sin_pitch*cos_roll + cos_yaw*sin_roll;
zup = cos_pitch*cos_roll;

xx = argument0+argument6*xto;
yy = argument1+argument6*yto;
zz = argument2+argument6*zto;

d3d_set_projection(xx,yy,zz,xx+xto,yy+yto,zz+zto,xup,yup,zup);
