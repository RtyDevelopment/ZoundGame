///draw_circle_glow(x,y,r,w,glowperc,col1,col2)
//glowperc*w=gloww
//col1=col
//col2=glowcol
var cx, cy, r, w, color, steps, alpha, gw, gcolor, galpha, i, j;
cx = argument0;
cy = argument1;
r = argument2;
w = argument3/2;    //Divide by 2 to center on radius
color = argument5;
steps = 24; //argument7;
alpha = draw_get_alpha();

//Draw glow
if (argument4>1) {
    gw = argument4*w;
    gcolor = argument6;
    galpha = (gw-w)/gw*alpha;
    
    draw_primitive_begin(pr_trianglestrip);
    for(i = 0;i <= steps;i += 1)
    {
        j = i/steps*360;
        draw_vertex_color(cx+lengthdir_x(r+gw, j), cy+lengthdir_y(r+gw, j), gcolor, 0);
        draw_vertex_color(cx+lengthdir_x(r+w, j), cy+lengthdir_y(r+w, j), gcolor, galpha);
    }
    draw_primitive_end();

    draw_primitive_begin(pr_trianglestrip);
    for(i = 0;i <= steps;i += 1)
    {
        j = i/steps*360;
        draw_vertex_color(cx+lengthdir_x(r-w, j), cy+lengthdir_y(r-w, j), gcolor, galpha);
        draw_vertex_color(cx+lengthdir_x(r-gw, j), cy+lengthdir_y(r-gw, j), gcolor, 0);
    }
    draw_primitive_end();
}

//Draw circle
draw_primitive_begin(pr_trianglestrip);
for(i = 0;i <= steps;i += 1)
{
    j = i/steps*360;
    draw_vertex_color(cx+lengthdir_x(r+w, j), cy+lengthdir_y(r+w, j), color, alpha);
    draw_vertex_color(cx+lengthdir_x(r-w, j), cy+lengthdir_y(r-w, j), color, alpha);
}
draw_primitive_end();
/*var surf, col, alpha, surfsize, i;
col = draw_get_color();
alpha = draw_get_alpha();
surfsize = argument2*2+argument3*argument4;
surf = surface_create(surfsize, surfsize);
surface_set_target(surf);
draw_set_color(argument6);
for (i=0; i<argument3*argument4/2; i+=1) {
    draw_set_alpha(1-i/(argument3*argument4/2));
    draw_circle(surfsize/2,surfsize/2,argument2+i,1);
    draw_circle(surfsize/2,surfsize/2,argument2-i,1);
}
draw_set_alpha(1);
draw_set_color(argument5);
for (i=0; i<argument3/2; i+=1) {
    draw_circle(surfsize/2,surfsize/2,argument2+i,1);
    draw_circle(surfsize/2,surfsize/2,argument2-i,1);
}
surface_reset_target();
draw_surface_ext(surf,argument0-surfsize/2,argument1-surfsize/2,1,1,0,c_white,alpha);
surface_free(surf);
draw_set_color(col);
draw_set_alpha(alpha);*/
