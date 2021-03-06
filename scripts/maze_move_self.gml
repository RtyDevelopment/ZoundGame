///maze_move_self(maze,x,y,dir,speed,bounce,gridsize,gridperc,objperc)
/*Returns:
(Real) inversed vector:
 0 = none;
 1 = x-vector
 2 = y-vector
*/
//Vars
var xres, yres, spd, grid, dir, wallperc, objrad, bounce;
xres = argument1/argument6;
yres = argument2/argument6;
spd = argument4/argument6;
grid = ds_grid_get(argument0, floor(xres), floor(yres));
dir = argument3;
wallperc = (1-argument7)/2;
objrad = argument8;
bounce = argument5+1;

var xmodif, ymodif, x_frac, y_frac, xnew, ynew, xnew_frac, ynew_frac, xinv, yinv;
xmodif = 0;
ymodif = 0;
x_frac = frac(xres);
y_frac = frac(yres);
xnew = xres+lengthdir_x(spd, dir);
ynew = yres+lengthdir_y(spd, dir);
xnew_frac = x_frac+lengthdir_x(spd, dir);
ynew_frac = y_frac+lengthdir_y(spd, dir);
xinv = false;
yinv = false;

var cornerLU, cornerLD, cornerRU, cornerRD;
cornerLU = 0;
cornerLD = 0;
cornerRU = 0;
cornerRD = 0;

//Maze walls
//RIGHT
if (string_char_at(grid, 2)=="0") {
    if (xnew_frac+objrad>1-wallperc) {
        xmodif -= (xnew_frac+objrad)-(1-wallperc);
        xinv ^= true;
    }
} else {
    //Corners available
    //  .    .xx
    //...    ---
    //
    //...    ---
    //  .    .xx
    cornerRU++;
    cornerRD++;
}
//LEFT
if (string_char_at(grid, 4)=="0") {
    if (xnew_frac-objrad<wallperc) {
        xmodif += wallperc-(xnew_frac-objrad);
        xinv ^= true;
    }
} else {
    //Corners available
    //xx.    .
    //---    ...
    //
    //---    ...
    //xx.    .
    cornerLU++;
    cornerLD++;
}
//DOWN
if (string_char_at(grid, 3)=="0") {
    if (ynew_frac+objrad>1-wallperc) {
        ymodif -= (ynew_frac+objrad)-(1-wallperc);
        yinv ^= true;
    }
} else {
    //Corners available
    //  .    .
    //...    ...
    //
    //..|    |..
    //xx|    |xx
    cornerLD++;
    cornerRD++;
}
//UP
if (string_char_at(grid, 1)=="0") {
    if (ynew_frac-objrad<wallperc) {
        ymodif += wallperc-(ynew_frac-objrad);
        yinv ^= true;
    }
} else {
    //Corners available
    //xx|    |xx
    //..|    |..
    //
    //...    ...
    //  .    .
    cornerLU++;
    cornerRU++;
}

//Corners
//LU
if (cornerLU==2) {
    var cornerx, cornery, tdir;
    cornerx = wallperc+objrad;
    cornery = wallperc+objrad;
    tdir = point_direction(x_frac, y_frac, cornerx, cornery);
    if (tdir<180) tdir+=360;
    mdir = dir;
    if (mdir>=0 && mdir<(tdir+180) mod 360) mdir+=360;
    if (mdir<tdir) {
        //Wall-RIGHT
        if (line_isect(cornerx, 0, cornerx, cornery, x_frac, y_frac, xnew_frac, ynew_frac, true)!=0) {
            xmodif += wallperc-(xnew_frac-objrad);
            xinv ^= true;
        }
    } else {
        //Wall-DOWN
        if (line_isect(0, cornery, cornerx, cornery, x_frac, y_frac, xnew_frac, ynew_frac, true)!=0) {
            ymodif += wallperc-(ynew_frac-objrad);
            yinv ^= true;
        }
    }
}

//RU
if (cornerRU==2) {
    var cornerx, cornery, tdir;
    cornerx = 1-wallperc-objrad;
    cornery = wallperc+objrad;
    tdir = point_direction(x_frac, y_frac, cornerx, cornery);
    if (tdir<180) tdir+=360;
    mdir = dir;
    if (mdir>=0 && mdir<(tdir+180) mod 360) mdir+=360;
    if (mdir<tdir) {
        //Wall-DOWN
        if (line_isect(cornerx, cornery, 1, cornery, x_frac, y_frac, xnew_frac, ynew_frac, true)!=0) {
            ymodif += wallperc-(ynew_frac-objrad);
            yinv ^= true;
        }
    } else {
        //Wall-LEFT
        if (line_isect(cornerx, 0, cornerx, cornery, x_frac, y_frac, xnew_frac, ynew_frac, true)!=0) {
            xmodif -= (xnew_frac+objrad)-(1-wallperc);
            xinv ^= true;
        }
    }
}

//RD
if (cornerRD==2) {
    var cornerx, cornery, tdir;
    cornerx = 1-wallperc-objrad;
    cornery = 1-wallperc-objrad;
    tdir = point_direction(x_frac, y_frac, cornerx, cornery);
    if (tdir<180) tdir+=360;
    mdir = dir;
    if (mdir>=0 && mdir<(tdir+180) mod 360) mdir+=360;
    if (mdir<tdir) {
        //Wall-LEFT
        if (line_isect(cornerx, cornery, cornerx, 1, x_frac, y_frac, xnew_frac, ynew_frac, true)!=0) {
            xmodif -= (xnew_frac+objrad)-(1-wallperc);
            xinv ^= true;
        }
    } else {
        //Wall-UP
        if (line_isect(cornerx, cornery, 1, cornery, x_frac, y_frac, xnew_frac, ynew_frac, true)!=0) {
            ymodif -= (ynew_frac+objrad)-(1-wallperc);
            yinv ^= true;
        }
    }
}

//LD
if (cornerLD==2) {
    var cornerx, cornery, tdir;
    cornerx = wallperc+objrad;
    cornery = 1-wallperc-objrad;
    tdir = point_direction(x_frac, y_frac, cornerx, cornery);
    if (tdir<180) tdir+=360;
    mdir = dir;
    if (mdir>=0 && mdir<(tdir+180) mod 360) mdir+=360;
    if (mdir<tdir) {
        //Wall-UP
        if (line_isect(0, cornery, cornerx, cornery, x_frac, y_frac, xnew_frac, ynew_frac, true)!=0) {
            ymodif -= (ynew_frac+objrad)-(1-wallperc);
            yinv ^= true;
        }
    } else {
        //Wall-RIGHT
        if (line_isect(cornerx, cornery, cornerx, 1, x_frac, y_frac, xnew_frac, ynew_frac, true)!=0) {
            xmodif += wallperc-(xnew_frac-objrad);
            xinv ^= true;
        }
    }
}

//Exec
self.x = (xnew+xmodif*bounce)*argument6;
self.y = (ynew+ymodif*bounce)*argument6;
if not (xinv==true ^^ yinv==true) {
    return 0;
} else if (xinv==true) {
    return 1;
} else if (yinv==true) {
    return 2;
}
