def_margin=0.1;

b_kirche   = 10.2;
t_kirche   = 19.9;
h_kSchiff  = 10;
t_turm     = 10.6;
h_turm     = 15.2;

b_haus     = 10;
t_haus     = 15;
h_haus     = 8;

b_str      = 5;
t_str      = 25.5;


module Kirche(width=b_kirche, count=1, margin=def_margin) {
    h_dach = h_turm + t_turm / 2;
    minkowski(){
        rotate([0,90,0])
            linear_extrude(height=width * count, convexity=10) {
                polygon(points=[
                    [0,0], [-h_turm,0], [-h_dach,t_turm / 2], [-h_turm, t_turm],
                    [-h_kSchiff,t_turm], [-h_kSchiff,t_kirche], [0,t_kirche]
                ]);
            }
        cube(2 * margin, center=true);
    }
}

module Haus(nx=1, ny=1, margin=def_margin) {
    h_dach = h_haus + b_haus / 2;
    for ( x = [0 : nx - 1], y = [0 : ny - 1] ) {
        translate([x * b_haus, y * t_haus, 0]) minkowski(){
            rotate([-90,0,0])
                linear_extrude(height=t_haus, convexity=10) {
                    polygon(points=[[0,0],[b_haus,0],[b_haus,-h_haus],[b_haus/2,-h_dach],[0,-h_haus]]);
                }
            cube(2 * margin, center=true);
        }
    }
}

module Strasse(nx=1, ny=1, margin=def_margin){
    for ( x = [0 : nx - 1], y = [0 : ny - 1] ) {
        translate([x * b_str - margin, y * b_str - margin, -margin])
            cube([b_str + 2 * margin, b_str + 2 * margin, t_str + 2 * margin]);
    }
}

r_ritter=19.5 / 2;
h_ritter=39.5 / 6;
b_mauer=21.5;
h_mauer=5.4;

module Ritter(count = 6, margin = def_margin){
    translate([-margin,r_ritter,r_ritter])
        rotate([0,90,0])
            cylinder(r=r_ritter + margin, h = count * h_ritter + 2 * margin, center=false, $fa=1, $fs=1);
}

module Mauer(margin=def_margin){
    translate([-margin, -margin,-margin]) cube([b_mauer + 2 * margin, h_mauer + 2 * margin, b_mauer + 2 * margin]);
}
