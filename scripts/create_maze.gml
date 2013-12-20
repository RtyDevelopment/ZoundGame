///WARNING DO NOT USE

//create_maze(width, height, chance1, chance2, chance3, chance4)

/*
0000    0000    0000

0000    0000    0000

0000    0000    0000
NESW

1=connection
0=wall
*/
/*
var grid, wallno, minconn, maxconn, setconn, connlist;
grid = ds_grid_create(argument0, argument1);

for (var i=0; i<argument0; i++) { //x
    for (var j=0; j<argument1; j++) { //y
        //Set default values
        minconn = 1;
        maxconn = 4;
        setconn = 0;
        connlist[0] = "-"; // N //0=conn, 1=wall, - =unset
        connlist[1] = "-"; // E
        connlist[2] = "-"; // S
        connlist[3] = "-"; // W
        //Check environment
        if (string_char_at(ds_grid_get(grid, i-1, j), 3)=="0" || i==0) { //If above is wall or empty; else above is conn
            maxconn--;
            connlist[0] = "1";
        } else {
            minconn++;
            setconn++;
            connlist[0] = "0";
        }
        if (i==argument0) {  //Check if at bottom; when true max available =-1;
            maxconn--;
            connlist[2] = "1";
        }
        if (string_char_at(ds_grid_get(grid, i, j-1), 2)=="0" || j==0) { //If left is wall or empty; else above is conn
            maxconn--;
            connlist[3] = "1";
        } else {
            minconn++;
            setconn++;
            connlist[3] = "0";
        }
        if (j==argument1) {  //Check if at right; when true max available =-1;
            maxconn--;
            connlist[1] = "1";
        }
        //Set chances according to available connections
        if (minconn<=1 && maxconn>=1) chance1 = argument2; else chance1 = 0;
        if (minconn<=2 && maxconn>=2) chance2 = argument3; else chance3 = 0;
        if (minconn<=3 && maxconn>=3) chance3 = argument4; else chance3 = 0;
        if (minconn<=4 && maxconn>=4) chance4 = argument5; else chance4 = 0;
        wallno = choose_weighted(1, chance1, 2, chance2, 3, chance3, 4, chance4);
        setconn-=wallno; //Set the amount of extra connections to be made
        
        if (connlist) chance1 = argument2; else chance1 = 0;
        if (minconn<=2 && maxconn>=2) chance2 = argument3; else chance3 = 0;
        if (minconn<=3 && maxconn>=3) chance3 = argument4; else chance3 = 0;
        if (minconn<=4 && maxconn>=4) chance4 = argument5; else chance4 = 0;
        wallno = choose_weighted(1, chance1, 2, chance2, 3, chance3, 4, chance4);
    }
}*/
