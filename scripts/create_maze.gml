//create_maze(width, height, chance1, chance2, chance3, chance4);
//Copyright Jasper Weyne (c) 2013

/*
0000    0000    0000

0000    0000    0000

0000    0000    0000
NESW

1=connection
0=wall
*/
var grid, minconn, maxconn, setconn, connspace, wallno, newconn, connlist, pilc;//, pillarxlist, pillarylist;

grid = ds_grid_create(argument0, argument1);

for (var i=0; i<argument0; i++) { //x
    for (var j=0; j<argument1; j++) { //y
        //Set default values
        minconn = 1;
        maxconn = 4;
        setconn = 0;   //Amount of preset connections
        connspace = 2; //Amount of unset connections
        wallno = 0;    //Amount of connections to be made (total)
        newconn = 0;   //Amount of connections to be made (from unset)
        connlist[0] = "-"; // N //0=conn, 1=wall, - =unset
        connlist[1] = "-"; // E
        connlist[2] = "-"; // S
        connlist[3] = "-"; // W
        
        //Check environment
        if (j==0) { //If above is wall or border; else above is conn
            maxconn--;
            connlist[0] = "0";
        } else {
            if (string_char_at(ds_grid_get(grid, i, j-1), 3)=="0") {
                maxconn--;
                connlist[0] = "0";
            } else {
                minconn++;
                setconn++; //Add existent connection
                connlist[0] = "1";
            }
        }
        if (j==argument1-1) {  //Check if at bottom; when true max available =-1;
            maxconn--;
            connspace--;
            connlist[2] = "0";
        }
        if (i==0) { //If left is wall or border; else left is conn
            maxconn--;
            connlist[3] = "0";
        } else {
            if (string_char_at(ds_grid_get(grid, i-1, j), 2)=="0") {
                maxconn--;
                connlist[3] = "0";
            } else {
                minconn++;
                setconn++; //Add existent connection
                connlist[3] = "1";
            }
        }
        if (i==argument0-1) {  //Check if at right; when true max available =-1;
            maxconn--;
            connspace--;
            connlist[1] = "0";
        }
        
        //Set chances according to available connections
        if (minconn<=1 && maxconn>=1) chance1 = argument2; else chance1 = 0;
        if (minconn<=2 && maxconn>=2) chance2 = argument3; else chance2 = 0;
        if (minconn<=3 && maxconn>=3) chance3 = argument4; else chance3 = 0;
        if (minconn<=4 && maxconn>=4) chance4 = argument5; else chance4 = 0;
        
        wallno = choose_weighted(1, chance1, 2, chance2, 3, chance3, 4, chance4);
        newconn = wallno-setconn; //Set the amount of new connections (subtract existent from total)
        
        for (var k=0; k<newconn; k++) {
            if (connlist[1]=="-") chance1 = 1; else chance1 = 0;
            if (connlist[2]=="-") chance2 = 1; else chance2 = 0;
            connlist[choose_weighted(1, chance1, 2, chance2)] = "1";
        }
        
        if (connlist[1]=="-") connlist[1] = "0";
        if (connlist[2]=="-") connlist[2] = "0";
        ds_grid_set(grid, i, j, connlist[0]+connlist[1]+connlist[2]+connlist[3]);
    }
}

ds_list_clear(pillarxlist);
ds_list_clear(pillarylist);

for (var i=1; i<argument0; i++) { //x
    for (var j=1; j<argument1; j++) { //y
        LB = ds_grid_get(grid, i-1, j-1);
        if (string_char_at(LB, 2) == "1" && string_char_at(LB, 3) == "1") {
            RB = ds_grid_get(grid, i, j-1);
            if (string_char_at(RB, 3) == "1" && string_char_at(RB, 4) == "1") {
                LO = ds_grid_get(grid, i-1, j);
                if (string_char_at(LO, 1) == "1" && string_char_at(LO, 2) == "1") {
                    RO = ds_grid_get(grid, i, j);
                    if (string_char_at(RO, 1) == "1" && string_char_at(RO, 4) == "1") {
                        ds_list_add(pillarxlist, i);
                        ds_list_add(pillarylist, j);
                    }
                }
            }
        }               
    }
}

ds_list_clear(linelistx);
ds_list_clear(linelisty);
ds_list_clear(dirlist);

for (var i=0; i<ds_list_size(pillarxlist); i++) { //cur
    curx = ds_list_find_value(pillarxlist, i);
    cury = ds_list_find_value(pillarylist, i);
    for (var j=0; j<ds_list_size(pillarxlist); j++) { //search
        searchx = ds_list_find_value(pillarxlist, j);
        searchy = ds_list_find_value(pillarylist, j);
        if (curx+1==searchx && cury==searchy) {
            ds_list_add(linelistx, curx);
            ds_list_add(linelisty, cury);
            ds_list_add(dirlist, 0);
            ds_grid_set(grid, curx, cury, string_set_at(ds_grid_get(grid, curx, cury), 1, "0"));
            ds_grid_set(grid, curx, cury-1, string_set_at(ds_grid_get(grid, curx, cury-1), 3, "0"));
            break;
        }
    }
    for (var j=0; j<ds_list_size(pillarxlist); j++) { //search
        searchx = ds_list_find_value(pillarxlist, j);
        searchy = ds_list_find_value(pillarylist, j);
        if (curx==searchx && cury+1==searchy) {
            ds_list_add(linelistx, curx);
            ds_list_add(linelisty, cury);
            ds_list_add(dirlist, 1);
            ds_grid_set(grid, curx, cury, string_set_at(ds_grid_get(grid, curx, cury), 4, "0"));
            ds_grid_set(grid, curx-1, cury, string_set_at(ds_grid_get(grid, curx-1, cury), 2, "0"));
            break;
        }
    }
}

ds_list_clear(emptylistx);
ds_list_clear(emptylisty);
ds_list_clear(emptylistval);

for (var i=0; i<argument0; i++) { //x
    for (var j=0; j<argument1; j++) { //y
        if (ds_grid_get(grid, i, j)=="0000") {
            ds_list_add(emptylistx, i);
            ds_list_add(emptylisty, j);
            ds_list_add(emptylistval, 1);
        }
    }
}

/*for (var i=0; i<ds_list_size(emptylistx); i++) { //cur
    curx = ds_list_find_value(emptylistx, i);
    cury = ds_list_find_value(emptylisty, i);
    for (var j=0; j<ds_list_size(emptylistx); j++) { //search
        searchx = ds_list_find_value(emptylistx, j);
        searchy = ds_list_find_value(emptylisty, j);
        if (curx+1==searchx && cury==searchy) {
            ds_grid_
            
    curx = ds_list_find_value(emptylistx, i);
    cury = ds_list_find_value(emptylisty, i);
    for (var j=0; j<ds_list_size(emptylistx); j++) { //search
        searchx = ds_list_find_value(emptylistx, j);
        searchy = ds_list_find_value(emptylisty, j);
        if (curx==searchx && cury+1==searchy) {
*/            

return grid;
