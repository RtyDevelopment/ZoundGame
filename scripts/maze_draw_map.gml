///maze_draw_map(maze,x,y,w,h,gridperc,color,width,color,r);
//               0    1 2 3 4 5        6     7     8     9

var maze, mazewidth, mazeheight, gridsizex, gridsizey, walldistx, walldisty, col;
maze = argument0;
mazewidth = ds_grid_width(maze);
mazeheight = ds_grid_height(maze);
gridsizex = argument3/mazewidth;
gridsizey = argument4/mazeheight;
walldistx = gridsizex*(1-argument5)/2;
walldisty = gridsizey*(1-argument5)/2;
col = draw_get_color();
draw_set_color(c_white);

for (var i=0; i<mazewidth; i++) {
    for (var j=0; j<mazeheight; j++) {
        //draw_rectangle(i*gridsizex+walldistx, j*gridsizey+walldisty, (i+1)*gridsizex-walldistx, (j+1)*gridsizey-walldisty, 0);
        if (string_char_at(ds_grid_get(maze, i, j), 1)=="0") {
            draw_line_width(argument1+i*gridsizex+walldistx, argument2+j*gridsizey+walldisty, argument1+(i+1)*gridsizex-walldistx, argument2+j*gridsizey+walldisty, argument7);//draw_line_glow(.., argument9, argument6, argument8);
        } else {
            //draw_rectangle(i*gridsizex+walldistx, j*gridsizey, (i+1)*gridsizex-walldistx, j*gridsizey+walldisty, 0);
            draw_line_width(argument1+i*gridsizex+walldistx, argument2+j*gridsizey, argument1+i*gridsizex+walldistx, argument2+j*gridsizey+walldisty, argument7);//draw_line_glow(.., argument9, argument6, argument8);
            draw_line_width(argument1+(i+1)*gridsizex-walldistx, argument2+j*gridsizey, argument1+(i+1)*gridsizex-walldistx, argument2+j*gridsizey+walldisty, argument7);//draw_line_glow(.., argument9, argument6, argument8);
        }
        if (string_char_at(ds_grid_get(maze, i, j), 2)=="0") {
            draw_line_width(argument1+(i+1)*gridsizex-walldistx, argument2+j*gridsizey+walldisty, (i+1)*gridsizex-walldistx, argument2+(j+1)*gridsizey-walldisty, argument7);//draw_line_glow(.., argument9, argument6, argument8);
        } else {
            //draw_rectangle((i+1)*gridsizex-walldistx, j*gridsizey+walldisty, (i+1)*gridsizex, (j+1)*gridsizey-walldisty, 0);
            draw_line_width(argument1+(i+1)*gridsizex-walldistx, argument2+j*gridsizey+walldisty, argument1+(i+1)*gridsizex, argument2+j*gridsizey+walldisty, argument7);//draw_line_glow(.., argument9, argument6, argument8);
            draw_line_width(argument1+(i+1)*gridsizex-walldistx, argument2+(j+1)*gridsizey-walldisty, argument1+(i+1)*gridsizex, argument2+(j+1)*gridsizey-walldisty, argument7);//draw_line_glow(.., argument9, argument6, argument8);
        }
        if (string_char_at(ds_grid_get(maze, i, j), 3)=="0") {
            draw_line_width(argument1+i*gridsizex+walldistx, argument2+(j+1)*gridsizey-walldisty, argument1+(i+1)*gridsizex-walldistx, argument2+(j+1)*gridsizey-walldisty, argument7);//draw_line_glow(.., argument9, argument6, argument8);
        } else {
            //draw_rectangle(i*gridsizex+walldistx, (j+1)*gridsizey-walldisty, (i+1)*gridsizex-walldistx, (j+1)*gridsizey, 0);
            draw_line_width(argument1+i*gridsizex+walldistx, argument2+(j+1)*gridsizey-walldisty, argument1+i*gridsizex+walldistx, argument2+(j+1)*gridsizey, argument7);//draw_line_glow(.., argument9, argument6, argument8);
            draw_line_width(argument1+(i+1)*gridsizex-walldistx, argument2+(j+1)*gridsizey-walldisty, argument1+(i+1)*gridsizex-walldistx, argument2+(j+1)*gridsizey, argument7);//draw_line_glow(.., argument9, argument6, argument8);
        }
        if (string_char_at(ds_grid_get(maze, i, j), 4)=="0") {
            draw_line_width(argument1+i*gridsizex+walldistx, argument2+j*gridsizey+walldisty, argument1+i*gridsizex+walldistx, argument2+(j+1)*gridsizey-walldisty, argument7);//draw_line_glow(.., argument9, argument6, argument8);
        } else {
            //draw_rectangle(i*gridsizex, j*gridsizey+walldisty, i*gridsizex+walldistx, (j+1)*gridsizey-walldisty, 0);
            draw_line_width(argument1+i*gridsizex, argument2+j*gridsizey+walldisty, argument1+i*gridsizex+walldistx, argument2+j*gridsizey+walldisty, argument7);//draw_line_glow(.., argument9, argument6, argument8);
            draw_line_width(argument1+i*gridsizex, argument2+(j+1)*gridsizey-walldisty, argument1+i*gridsizex+walldistx, argument2+(j+1)*gridsizey-walldisty, argument7);//draw_line_glow(.., argument9, argument6, argument8);
        }
    }
}
draw_set_color(col);
