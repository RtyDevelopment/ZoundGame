///maze_draw_d3d(maze,x1,y1,z1,x2,y2,z2,texwall,texcorner,gridperc)
var maze, mazewidth, mazeheight, gridsizex, gridsizey, walldistx, walldisty;
maze = argument0;
mazewidth = ds_grid_width(maze);
mazeheight = ds_grid_height(maze);
gridsizex = (argument4-argument1)/mazewidth;
gridsizey = (argument5-argument2)/mazeheight;
walldistx = gridsizex*(1-argument9)/2;
walldisty = gridsizey*(1-argument9)/2;

for (var i=0; i<mazewidth; i++) {
    for (var j=0; j<mazeheight; j++) {
        if (string_char_at(ds_grid_get(maze, i, j), 1)=="0") {
            d3d_draw_wall(argument1+i*gridsizex+walldistx, argument2+j*gridsizey+walldisty, argument3, argument1+(i+1)*gridsizex-walldistx, argument2+j*gridsizey+walldisty, argument6, argument7, 1, 1);
        } else {
            d3d_draw_wall(argument1+i*gridsizex+walldistx, argument2+j*gridsizey, argument3, argument1+i*gridsizex+walldistx, argument2+j*gridsizey+walldisty, argument6, argument8, 1, 1);
            d3d_draw_wall(argument1+(i+1)*gridsizex-walldistx, argument2+j*gridsizey, argument3, argument1+(i+1)*gridsizex-walldistx, argument2+j*gridsizey+walldisty, argument6, argument8, 1, 1);
        }
        if (string_char_at(ds_grid_get(maze, i, j), 2)=="0") {
            d3d_draw_wall(argument1+(i+1)*gridsizex-walldistx, argument2+j*gridsizey+walldisty, argument3, (i+1)*gridsizex-walldistx, argument2+(j+1)*gridsizey-walldisty, argument6, argument7, 1, 1);
        } else {
            d3d_draw_wall(argument1+(i+1)*gridsizex-walldistx, argument2+j*gridsizey+walldisty, argument3, argument1+(i+1)*gridsizex, argument2+j*gridsizey+walldisty, argument6, argument8, 1, 1);
            d3d_draw_wall(argument1+(i+1)*gridsizex-walldistx, argument2+(j+1)*gridsizey-walldisty, argument3, argument1+(i+1)*gridsizex, argument2+(j+1)*gridsizey-walldisty, argument6, argument8, 1, 1);
        }
        if (string_char_at(ds_grid_get(maze, i, j), 3)=="0") {
            d3d_draw_wall(argument1+i*gridsizex+walldistx, argument2+(j+1)*gridsizey-walldisty, argument3, argument1+(i+1)*gridsizex-walldistx, argument2+(j+1)*gridsizey-walldisty, argument6, argument7, 1, 1);
        } else {
            d3d_draw_wall(argument1+i*gridsizex+walldistx, argument2+(j+1)*gridsizey-walldisty, argument3, argument1+i*gridsizex+walldistx, argument2+(j+1)*gridsizey, argument6, argument8, 1, 1);
            d3d_draw_wall(argument1+(i+1)*gridsizex-walldistx, argument2+(j+1)*gridsizey-walldisty, argument3, argument1+(i+1)*gridsizex-walldistx, argument2+(j+1)*gridsizey, argument6, argument8, 1, 1);
        }
        if (string_char_at(ds_grid_get(maze, i, j), 4)=="0") {
            d3d_draw_wall(argument1+i*gridsizex+walldistx, argument2+j*gridsizey+walldisty, argument3, argument1+i*gridsizex+walldistx, argument2+(j+1)*gridsizey-walldisty, argument6, argument7, 1, 1);
        } else {
            d3d_draw_wall(argument1+i*gridsizex, argument2+j*gridsizey+walldisty, argument3, argument1+i*gridsizex+walldistx, argument2+j*gridsizey+walldisty, argument6, argument8, 1, 1);
            d3d_draw_wall(argument1+i*gridsizex, argument2+(j+1)*gridsizey-walldisty, argument3, argument1+i*gridsizex+walldistx, argument2+(j+1)*gridsizey-walldisty, argument6, argument8, 1, 1);
        }
    }
}
