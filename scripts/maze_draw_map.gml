///maze_draw_map(maze,x,y,w,h,gridperc,color,width,color,r);
//               0    1 2 3 4 5        6     7     8     9

var maze, mazewidth, mazeheight;
maze = argument0;
mazewidth = ds_grid_width(maze);
mazeheight = ds_grid_height(maze);
gridsizex = argument3/mazewidth;
gridsizey = argument4/mazeheight;
walldistx = gridsizex*(1-argument5)/2;
walldisty = gridsizey*(1-argument5)/2;

for (var i=0; i<mazewidth; i++) {
    for (var j=0; j<mazeheight; j++) {
        //draw_set_color(c_dkgray);
        //draw_rectangle(i*gridsize+walldist, j*gridsize+walldist, (i+1)*gridsize-walldist, (j+1)*gridsize-walldist, 0);
        //draw_set_color(c_white);
        if (string_char_at(ds_grid_get(maze, i, j), 1)=="0") {
            draw_line_glow(i*gridsize+walldist, j*gridsize+walldist, (i+1)*gridsize-walldist, j*gridsize+walldist, 3, 3, argument6, argument8);
        } else {
            //draw_set_color(c_dkgray);
            //draw_rectangle(i*gridsize+walldist, j*gridsize, (i+1)*gridsize-walldist, j*gridsize+walldist, 0);
            //draw_set_color(c_white);
            draw_line_glow(i*gridsize+walldist, j*gridsize, i*gridsize+walldist, j*gridsize+walldist, 3, 3, argument6, argument8);
            draw_line_glow((i+1)*gridsize-walldist, j*gridsize, (i+1)*gridsize-walldist, j*gridsize+walldist, 3, 3, argument6, argument8);
        }
        if (string_char_at(ds_grid_get(maze, i, j), 2)=="0") {
            draw_line_glow((i+1)*gridsize-walldist, j*gridsize+walldist, (i+1)*gridsize-walldist, (j+1)*gridsize-walldist, 3, 3, argument6, argument8);
        } else {
            //draw_set_color(c_dkgray);
            //draw_rectangle((i+1)*gridsize-walldist, j*gridsize+walldist, (i+1)*gridsize, (j+1)*gridsize-walldist, 0);
            //draw_set_color(c_white);
            draw_line_glow((i+1)*gridsize-walldist, j*gridsize+walldist, (i+1)*gridsize, j*gridsize+walldist, 3, 3, argument6, argument8);
            draw_line_glow((i+1)*gridsize-walldist, (j+1)*gridsize-walldist, (i+1)*gridsize, (j+1)*gridsize-walldist, 3, 3, argument6, argument8);
        }
        if (string_char_at(ds_grid_get(maze, i, j), 3)=="0") {
            draw_line_glow(i*gridsize+walldist, (j+1)*gridsize-walldist, (i+1)*gridsize-walldist, (j+1)*gridsize-walldist, 3, 3, argument6, argument8);
        } else {
            //draw_set_color(c_dkgray);
            //draw_rectangle(i*gridsize+walldist, (j+1)*gridsize-walldist, (i+1)*gridsize-walldist, (j+1)*gridsize, 0);
            //draw_set_color(c_white);
            draw_line_glow(i*gridsize+walldist, (j+1)*gridsize-walldist, i*gridsize+walldist, (j+1)*gridsize, 3, 3, argument6, argument8);
            draw_line_glow((i+1)*gridsize-walldist, (j+1)*gridsize-walldist, (i+1)*gridsize-walldist, (j+1)*gridsize, 3, 3, argument6, argument8);
        }
        if (string_char_at(ds_grid_get(maze, i, j), 4)=="0") {
            draw_line_glow(i*gridsize+walldist, j*gridsize+walldist, i*gridsize+walldist, (j+1)*gridsize-walldist, 3, 3, argument6, argument8);
        } else {
            //draw_set_color(c_dkgray);
            //draw_rectangle(i*gridsize, j*gridsize+walldist, i*gridsize+walldist, (j+1)*gridsize-walldist, 0);
            //draw_set_color(c_white);
            draw_line_glow(i*gridsize, j*gridsize+walldist, i*gridsize+walldist, j*gridsize+walldist, 3, 3, argument6, argument8);
            draw_line_glow(i*gridsize, (j+1)*gridsize-walldist, i*gridsize+walldist, (j+1)*gridsize-walldist, 3, 3, argument6, argument8);
        }
    }
}
