def_margin = 0.125;

b_kirche   = 10.2;
t_kirche   = 19.9;
h_kSchiff  = 10;
t_turm     = 10.6;
h_turm     = 15.2;

b_haus     = 10;
b_haus     = 9.8;
t_haus     = 15;
h_haus     = 8;

b_str      = 5;
t_str      = 25.5;


module Kirche(width=b_kirche, count=1, margin=def_margin) {
    h_dach = h_turm + t_turm / 2;
    translate([-margin, 0, 0])
        rotate([0,90,0])
            linear_extrude(height=width * count + 2*margin, convexity=10)
                polygon(points=[
                    [             margin,             -margin],
                    [   -h_turm - margin,             -margin],
                    [   -h_dach - margin, t_turm / 2 - margin],
                    [   -h_dach - margin, t_turm / 2 + margin],
                    [   -h_turm - margin,     t_turm + margin],
                    [-h_kSchiff - margin,     t_turm + margin],
                    [-h_kSchiff - margin,   t_kirche + margin],
                    [             margin,   t_kirche + margin]
                ]);
}

module Haus(nx=1, ny=1, margin=def_margin) {
    h_dach = h_haus + b_haus / 2;
    for ( x = [0 : nx - 1], y = [0 : ny - 1] ) {
        translate([x * b_haus, y * t_haus - margin, 0])
            rotate([-90,0,0])
                linear_extrude(height=t_haus + 2 * margin, convexity=10)
                    polygon(points=[
                        [-margin, margin],
                        [b_haus + margin, margin],
                        [b_haus + margin, -h_haus - margin],
                        [b_haus/2 + margin, -h_dach - margin],
                        [b_haus/2 - margin, -h_dach - margin],
                        [-margin, -h_haus - margin]
                    ]);
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
            cylinder(r=r_ritter + margin, h = count * h_ritter + 2 * margin, center=false, $fn=32);
}

module Mauer(margin=def_margin){
    translate([-margin, -margin,-margin]) cube([b_mauer + 2 * margin, h_mauer + 2 * margin, b_mauer + 2 * margin]);
}
