///create_maze(w,h);
//Copyright Jasper Weyne (c) 2013

/*
0000    0000    0000

0000    0000    0000

0000    0000    0000
NESW

1=connection
0=wall
*/
var grid, listx1, listy1, listx2, listy2, minconn, maxconn, setconn, wallno, connlist, index, first, selfx, selfy, searchx, searchy;

grid = ds_grid_create(argument0, argument1);
listx1 = ds_list_create();
listy1 = ds_list_create();

for (var i=0; i<argument0; i++) { //x
    for (var j=0; j<argument1; j++) { //y
        //Set default values
        minconn = 1;
        maxconn = 4;
        setconn = 0;   //Amount of preset connections
        wallno = 0;    //Amount of connections to be made (total)
        connlist[0] = "-"; // N //0=conn, 1=wall, - =unset
        connlist[1] = "-"; // E
        connlist[2] = "-"; // S
        connlist[3] = "-"; // W
        
        //Check environment
        if (j==0) { //If above is wall or border; else above is conn
            if (minconn!=maxconn) maxconn--;
            connlist[0] = "0";
        } else {
            if (string_char_at(ds_grid_get(grid, i, j-1), 3)=="0") {
                if (minconn!=maxconn) maxconn--;
                connlist[0] = "0";
            } else {
                if (minconn!=maxconn) minconn++;
                setconn++; //Add existent connection
                connlist[0] = "1";
            }
        }
        if (j==argument1-1) {  //Check if at bottom; when true max available =-1;
            if (minconn==maxconn) minconn--; maxconn--;
            connlist[2] = "0";
        }
        if (i==0) { //If left is wall or border; else left is conn
            if (minconn!=maxconn) maxconn--;
            connlist[3] = "0";
        } else {
            if (string_char_at(ds_grid_get(grid, i-1, j), 2)=="0") {
                if (minconn!=maxconn) maxconn--;
                connlist[3] = "0";
            } else {
                if (minconn!=maxconn) minconn++;
                setconn++; //Add existent connection
                connlist[3] = "1";
            }
        }
        if (i==argument0-1) {  //Check if at right; when true max available =-1;
            if (minconn==maxconn) minconn--; maxconn--;
            connlist[1] = "0";
        }
        
        //Set chances according to available connections
        if (minconn<=1 && maxconn>=1) chance1 = 4; else chance1 = 0;
        if (minconn<=2 && maxconn>=2) chance2 = 3; else chance2 = 0;
        if (minconn<=3 && maxconn>=3) chance3 = 2; else chance3 = 0;
        if (minconn<=4 && maxconn>=4) chance4 = 1; else chance4 = 0;
        wallno = choose_weighted(1, chance1, 2, chance2, 3, chance3, 4, chance4);
        
        for (var k=0; k<wallno-setconn; k++) { //Set the amount of new connections (subtract existent from total)
            if (connlist[1]=="-") chance1 = 1; else chance1 = 0;
            if (connlist[2]=="-") chance2 = 1; else chance2 = 0;
            connlist[choose_weighted(1, chance1, 2, chance2)] = "1";
        }
        
        if (connlist[1]=="-") connlist[1] = "0";
        if (connlist[2]=="-") connlist[2] = "0";
        ds_grid_set(grid, i, j, connlist[0]+connlist[1]+connlist[2]+connlist[3]);
    }
}

//join pillars
ds_list_clear(listx1);
ds_list_clear(listy1);

for (var i=1; i<argument0; i++) { //x
    for (var j=1; j<argument1; j++) { //y
        var LB = ds_grid_get(grid, i-1, j-1);
        if (string_char_at(LB, 2) == "1" && string_char_at(LB, 3) == "1") {
            var RB = ds_grid_get(grid, i, j-1);
            if (string_char_at(RB, 3) == "1" && string_char_at(RB, 4) == "1") {
                var LO = ds_grid_get(grid, i-1, j);
                if (string_char_at(LO, 1) == "1" && string_char_at(LO, 2) == "1") {
                    var RO = ds_grid_get(grid, i, j);
                    if (string_char_at(RO, 1) == "1" && string_char_at(RO, 4) == "1") {
                        ds_list_add(listx1, i);
                        ds_list_add(listy1, j);
                    }
                }
            }
        }               
    }
}

for (var i=0; i<ds_list_size(listx1); i++) { //cur
    selfx = ds_list_find_value(listx1, i);
    selfy = ds_list_find_value(listy1, i);
    for (var j=0; j<ds_list_size(listx1); j++) { //search
        searchx = ds_list_find_value(listx1, j);
        searchy = ds_list_find_value(listy1, j);
        if (selfx+1==searchx && selfy==searchy) {
            ds_grid_set(grid, selfx, selfy, string_set_at(ds_grid_get(grid, selfx, selfy), 1, "0"));
            ds_grid_set(grid, selfx, selfy-1, string_set_at(ds_grid_get(grid, selfx, selfy-1), 3, "0"));
            break;
        }
    }
    for (var j=0; j<ds_list_size(listx1); j++) { //search
        searchx = ds_list_find_value(listx1, j);
        searchy = ds_list_find_value(listy1, j);
        if (selfx==searchx && selfy+1==searchy) {
            ds_grid_set(grid, selfx, selfy, string_set_at(ds_grid_get(grid, selfx, selfy), 4, "0"));
            ds_grid_set(grid, selfx-1, selfy, string_set_at(ds_grid_get(grid, selfx-1, selfy), 2, "0"));
            break;
        }
    }
}

//join dead blocks
ds_list_clear(listx1);
ds_list_clear(listy1);

for (var i=0; i<argument0; i++) { //x
    for (var j=0; j<argument1; j++) { //y
        if (ds_grid_get(grid, i, j)=="0000") {
            ds_list_add(listx1, i);
            ds_list_add(listy1, j);
        }
    }
}

for (var i=0; i<ds_list_size(listx1); i++) { //cur
    selfx = ds_list_find_value(listx1, i);
    selfy = ds_list_find_value(listy1, i);
    for (var j=0; j<ds_list_size(listx1); j++) { //search
        searchx = ds_list_find_value(listx1, j);
        searchy = ds_list_find_value(listy1, j);
        if (selfx+1==searchx && selfy==searchy) {
            ds_grid_set(grid, searchx, searchy, string_set_at(ds_grid_get(grid, searchx, searchy), 4, "1"));
            ds_grid_set(grid, selfx, selfy, string_set_at(ds_grid_get(grid, selfx, selfy), 2, "1"));
            break;
        }
    }
    for (var j=0; j<ds_list_size(listx1); j++) { //search
        searchx = ds_list_find_value(listx1, j);
        searchy = ds_list_find_value(listy1, j);
        if (selfx==searchx && selfy+1==searchy) {
            ds_grid_set(grid, searchx, searchy, string_set_at(ds_grid_get(grid, searchx, searchy), 1, "1"));
            ds_grid_set(grid, selfx, selfy, string_set_at(ds_grid_get(grid, selfx, selfy), 3, "1"));
            break;
        }
    }
}

//connect unconnected map parts
ds_list_clear(listx1);
ds_list_clear(listy1);
listx2 = ds_list_create();
listy2 = ds_list_create();
first = true;

while (ds_list_empty(listx2)==false || first==true) {
    if (first==false) {
        selfx = ds_list_find_value(listx2, 0);
        selfy = ds_list_find_value(listy2, 0);
        self_ = ds_grid_get(grid, selfx, selfy);
        if (string_char_at(self_, 1)=="0" && selfy!=0) chance1 = 1; else chance1 = 0;
        if (string_char_at(self_, 2)=="0" && selfx!=argument0-1) chance2 = 1; else chance2 = 0;
        if (string_char_at(self_, 3)=="0" && selfy!=argument1-1) chance3 = 1; else chance3 = 0;
        if (string_char_at(self_, 4)=="0" && selfx!=0) chance4 = 1; else chance4 = 0;
        index = choose_weighted(1, chance1, 2, chance2, 3, chance3, 4, chance4);
        ds_grid_set(grid, selfx, selfy, string_set_at(self_, index, "1"));
        switch (index) {
            case 1: //north
                searchx = selfx;
                searchy = selfy-1;
                index = 3;
                break;
            case 2: //east
                searchx = selfx+1;
                searchy = selfy;
                index = 4;
                break;
            case 3: //south
                searchx = selfx;
                searchy = selfy+1;
                index = 1;
                break;
            case 4: //west
                searchx = selfx-1;
                searchy = selfy;
                index = 2;
                break;
        }
        ds_grid_set(grid, searchx, searchy, string_set_at(ds_grid_get(grid, searchx, searchy), index, "1"));
    }
    
    ds_list_clear(listx1);
    ds_list_clear(listy1);
    ds_list_add(listx1, 0);
    ds_list_add(listy1, 0);
    
    ds_list_clear(listx2);
    ds_list_clear(listy2);
    for (var i=0; i<argument1+argument0; i++) {
        if (i<argument1) {
            for (var j=0; j<argument0 && j<=i; j++) {
                ds_list_add(listx2, j);
                ds_list_add(listy2, i-j);
            }
        } else {
            for (var j=1; j<argument1 && j<argument0+argument1-i; j++) {
                ds_list_add(listx2, i-argument1+j);
                ds_list_add(listy2, argument1-j);
            }
        }
    }
    
    while (ds_list_empty(listx1)==false) {
        selfx = ds_list_find_value(listx1, 0);
        selfy = ds_list_find_value(listy1, 0);
        
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
                //if side is not in queue and still in set, add to queue (last)
                if (in_list_double(searchx, searchy, listx2, listy2)!=-1 && in_list_double(searchx, searchy, listx1, listy1)==-1) {
                    ds_list_add(listx1, searchx);
                    ds_list_add(listy1, searchy);
                }
            }
        }
        
        //remove from set
        index = in_list_double(selfx, selfy, listx2, listy2);
        ds_list_delete(listx2, index);
        ds_list_delete(listy2, index);
        
        //remove self from queue (first)
        ds_list_delete(listx1, 0);
        ds_list_delete(listy1, 0);
    }
    first = false;
}
ds_list_destroy(listx1);
ds_list_destroy(listy1);
ds_list_destroy(listx2);
ds_list_destroy(listy2);
//*/

return grid;
