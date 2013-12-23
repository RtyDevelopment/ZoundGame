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
var grid, minconn, maxconn, setconn, connspace, wallno, newconn, connlist;//, listx1, listy1;

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

ds_list_clear(listx1);
ds_list_clear(listy1);

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
                        ds_list_add(listx1, i);
                        ds_list_add(listy1, j);
                    }
                }
            }
        }               
    }
}

ds_list_clear(listy2);
ds_list_clear(listy2);
ds_list_clear(dirlist);

for (var i=0; i<ds_list_size(listx1); i++) { //cur
    selfx = ds_list_find_value(listx1, i);
    selfy = ds_list_find_value(listy1, i);
    for (var j=0; j<ds_list_size(listx1); j++) { //search
        searchx = ds_list_find_value(listx1, j);
        searchy = ds_list_find_value(listy1, j);
        if (selfx+1==searchx && selfy==searchy) {
            ds_list_add(listy2, selfx);
            ds_list_add(listy2, selfy);
            ds_list_add(dirlist, 0);
            ds_grid_set(grid, selfx, selfy, string_set_at(ds_grid_get(grid, selfx, selfy), 1, "0"));
            ds_grid_set(grid, selfx, selfy-1, string_set_at(ds_grid_get(grid, selfx, selfy-1), 3, "0"));
            break;
        }
    }
    for (var j=0; j<ds_list_size(listx1); j++) { //search
        searchx = ds_list_find_value(listx1, j);
        searchy = ds_list_find_value(listy1, j);
        if (selfx==searchx && selfy+1==searchy) {
            ds_list_add(listy2, selfx);
            ds_list_add(listy2, selfy);
            ds_list_add(dirlist, 1);
            ds_grid_set(grid, selfx, selfy, string_set_at(ds_grid_get(grid, selfx, selfy), 4, "0"));
            ds_grid_set(grid, selfx-1, selfy, string_set_at(ds_grid_get(grid, selfx-1, selfy), 2, "0"));
            break;
        }
    }
}

ds_list_clear(emptylistx);
ds_list_clear(emptylisty);

for (var i=0; i<argument0; i++) { //x
    for (var j=0; j<argument1; j++) { //y
        if (ds_grid_get(grid, i, j)=="0000") {
            ds_list_add(emptylistx, i);
            ds_list_add(emptylisty, j);
        }
    }
}

for (var i=0; i<ds_list_size(emptylistx); i++) { //cur
    selfx = ds_list_find_value(emptylistx, i);
    selfy = ds_list_find_value(emptylisty, i);
    for (var j=0; j<ds_list_size(emptylistx); j++) { //search
        searchx = ds_list_find_value(emptylistx, j);
        searchy = ds_list_find_value(emptylisty, j);
        if (selfx+1==searchx && selfy==searchy) {
            ds_grid_set(grid, searchx, searchy, string_set_at(ds_grid_get(grid, searchx, searchy), 4, "1"));
            ds_grid_set(grid, selfx, selfy, string_set_at(ds_grid_get(grid, selfx, selfy), 2, "1"));
            break;
        }
    }
    selfx = ds_list_find_value(emptylistx, i);
    selfy = ds_list_find_value(emptylisty, i);
    for (var j=0; j<ds_list_size(emptylistx); j++) { //search
        searchx = ds_list_find_value(emptylistx, j);
        searchy = ds_list_find_value(emptylisty, j);
        if (selfx==searchx && selfy+1==searchy) {
            ds_grid_set(grid, searchx, searchy, string_set_at(ds_grid_get(grid, searchx, searchy), 1, "1"));
            ds_grid_set(grid, selfx, selfy, string_set_at(ds_grid_get(grid, selfx, selfy), 3, "1"));
            break;
        }
    }
}


unsetx = ds_list_create();
unsety = ds_list_create();
first = true;

while (ds_list_empty(unsetx)==false || first==true) {
    if (first==false) {
        index = floor(random(ds_list_size(unsetx)));
        selfx = ds_list_find_value(unsetx, index);
        selfy = ds_list_find_value(unsety, index);
        self_ = ds_grid_get(grid, selfx, selfy);
        if (string_char_at(self_, 1)=="0") chance1 = 1; else chance1 = 0;
        if (string_char_at(self_, 2)=="0") chance2 = 1; else chance2 = 0;
        if (string_char_at(self_, 3)=="0") chance3 = 1; else chance3 = 0;
        if (string_char_at(self_, 4)=="0") chance4 = 1; else chance4 = 0;
        wallindex = choose_weighted(1, chance1, 2, chance2, 3, chance3, 4, chance4);
        ds_grid_set(grid, selfx, selfy, string_set_at(self_, wallindex, "1"));
        switch (wallindex) {
            case 1: //north
                searchx = selfx;
                searchy = selfy-1;
                wallindex = 3;
                break;
            case 2: //east
                searchx = selfx+1;
                searchy = selfy;
                wallindex = 4;
                break;
            case 3: //south
                searchx = selfx;
                searchy = selfy+1;
                wallindex = 1;
                break;
            case 4: //west
                searchx = selfx-1;
                searchy = selfy;
                wallindex = 2;
                break;
        }
        ds_grid_set(grid, searchx, searchy, string_set_at(ds_grid_get(grid, searchx, searchy), wallindex, "1"));
    }
    ds_list_clear(connectx);
    ds_list_clear(connecty);
    queuex = ds_list_create();
    queuey = ds_list_create();
    ds_list_add(queuex, 0);
    ds_list_add(queuey, 0);
    
    ds_list_clear(unsetx);
    ds_list_clear(unsety);
    for (var i=0; i<argument0; i++) {
        for (var j=0; j<argument1; j++) {
            ds_list_add(unsetx, i);
            ds_list_add(unsety, j);
        }
    }
    
    while (ds_list_empty(queuex)==false) {
        selfx = ds_list_find_value(queuex, 0);
        selfy = ds_list_find_value(queuey, 0);
        
        //for each side
        for (var i=1; i<=4; i++) {
            //if side is adjectent
            if (string_char_at(ds_grid_get(grid, selfx, selfy), i)=="1") {
                //define adjectent x and y
                switch (i) {
                    case 1: //north
                        searchx = selfx;
                        searchy = selfy-1;
                        break;
                    case 2: //east
                        searchx = selfx+1;
                        searchy = selfy;
                        break;
                    case 3: //south
                        searchx = selfx;
                        searchy = selfy+1;
                        break;
                    case 4: //west
                        searchx = selfx-1;
                        searchy = selfy;
                        break;
                }
                //if side is not in queue and not in set, add to queue (last)
                if (in_list_double(searchx, searchy, connectx, connecty)==-1 && in_list_double(searchx, searchy, queuex, queuey)==-1) {
                    ds_list_add(queuex, searchx);
                    ds_list_add(queuey, searchy);
                }
            }
        }
        
        //add self to set and remove from unchecked
        ds_list_add(connectx, selfx);
        ds_list_add(connecty, selfy);
        index = in_list_double(selfx, selfy, unsetx, unsety);
        ds_list_delete(unsetx, index);
        ds_list_delete(unsety, index);
        
        //remove self from queue (first)
        ds_list_delete(queuex, 0);
        ds_list_delete(queuey, 0);
    }
    
    ds_list_destroy(queuex);
    ds_list_destroy(queuey);
    first = false;
}

return grid;
