///draw_circle_glow(x,y,r,w,glowperc,col1,col2)
//glowperc*w=gloww
//col1=col
//col2=glowcol
var surf, col, alpha, surfsize, i;
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
draw_set_alpha(alpha);
