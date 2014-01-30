///line_seg_dist(x2,y2,x3,y3,x4,y4,x4,y4)
/* segment_distance()
Returns the distance between two line segments.

args:
0 x1
1 y1
2 x2
3 y2
4 x3
5 y3
6 x4
7 y4

uses: line_to_point()

returns: distance
*/

var x1, y1, x2, y2, x3, y3, x4, y4, xa, ya, xb, yb, a, b, t;

x1 = argument0;
y1 = argument1;
x2 = argument2;
y2 = argument3;
x3 = argument4;
y3 = argument5;
x4 = argument6;
y4 = argument7;

globalvar drawlines;
ds_list_add(drawlines, x1);
ds_list_add(drawlines, y1);
ds_list_add(drawlines, x2);
ds_list_add(drawlines, y2);
ds_list_add(drawlines, x3);
ds_list_add(drawlines, y3);
ds_list_add(drawlines, x4);
ds_list_add(drawlines, y4);

a = 0;
b = 0;

// segment 1 has zero length
if (x1==x2 && y1==y2) a = 1;
// segment 2 has zero length
if (x3==x4 && y3==y4) b = 1;

if (a==1 && b==1) {// both segments have zero length
    return point_distance(x1,y1,x3,y3);
} else if a || b { // only 1 segment has zero length
    if a {
        t = min(max(0,_line_seg_dist_ltp(x1,y1,x3,y3,x4,y4)),1);
        return point_distance(x1,y1,x3+t*(x4-x3),y3+t*(y4-y3));
    } else {
        t = min(max(0,_line_seg_dist_ltp(x3,y3,x1,y1,x2,y2)),1);
        return point_distance(x3,y3,x1+t*(x2-x1),y1+t*(y2-y1));
    }
} else { // no segments have zero length
    t = (y4-y3)*(x2-x1) - (x4-x3)*(y2-y1);
    a = (x4-x3)*(y1-y3) - (y4-y3)*(x1-x3);

    if t != 0 { // not parallel
        a /= t;
        b = (x2-x1)*(y1-y3) - (y2-y1)*(x1-x3);
        b /= t;

        if a >= 0 && a <= 1 && b >= 0 && b <= 1 {// segment intersection
            return 0;
        } else { // no segment intersection
            t = min(max(0,a),1);
            xa = x1 + t * (x2-x1);
            ya = y1 + t * (y2-y1);
            t = min(max(0,_line_seg_dist_ltp(xa,ya,x3,y3,x4,y4)),1);

            xa = x3 + t * (x4-x3);
            ya = y3 + t * (y4-y3);

            t = min(max(0,b ),1);
            xb = x3 + t * (x4-x3);
            yb = y3 + t * (y4-y3);
            t = min(max(0,_line_seg_dist_ltp(xb,yb,x1,y1,x2,y2)),1);
            xb = x1 + t * (x2-x1);
            yb = y1 + t * (y2-y1);

            return point_distance(xa,ya,xb,yb);
        }
    } else if a != 0 { // parallel
        a = _line_seg_dist_ltp(x1,y1,x3,y3,x4,y4);

        if a <= 1 && a >= 0 {
            t = a;
            xa = x3 + t * (x4-x3);
            ya = y3 + t * (y4-y3);
            xb = x1;
            yb = y1;
        } else {
            t = min(max(0,a),1);
            xa = x3 + t * (x4-x3);
            ya = y3 + t * (y4-y3);
            t = min(max(0,_line_seg_dist_ltp(xa,ya,x1,y1,x2,y2)),1);
            xb = x1 + t * (x2-x1);
            yb = y1 + t * (y2-y1);
        }

        return point_distance(xa,ya,xb,yb);
    } else {// colinear
        return 0;
    }
}
