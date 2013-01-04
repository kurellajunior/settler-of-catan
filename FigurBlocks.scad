include <Figuren.scad>

b_kirche_4 = 4 * b_kirche;
b_haus_5   = 5 * b_haus;
b_str_5    = 5 * b_str;
b_str_5_2  = 2 * b_str_5 + 1 + 2*def_margin;
b_4k_2s    = 2 * b_str + b_kirche_4;
h_ritter_6 = 6 * h_ritter;

b_max_str   = max(b_str_5_2, b_4k_2s);
b_basisFiguren  = max(b_haus_5, b_max_str);
b_ritterFiguren = h_ritter_6 + 2 * h_mauer;

module BasisFiguren(){
	// Kirchen
	translate([(b_basisFiguren - b_kirche_4) / 2, 0, 0]) Kirche(width = b_kirche_4);
	// Houses
	translate([(b_basisFiguren - b_haus_5) / 2, t_turm, h_kSchiff]) Haus(nx=5);
	// Straße 1-4
	translate([(b_basisFiguren - b_max_str) / 2, 0,     0]) Strasse();
	translate([(b_basisFiguren - b_max_str) / 2, b_str, 0]) Strasse();
	translate([(b_basisFiguren - b_max_str) / 2, t_turm - b_str, 0]) Strasse();
	translate([b_basisFiguren - (b_basisFiguren - b_max_str) / 2 - b_str, 0,     0]) Strasse();
	translate([b_basisFiguren - (b_basisFiguren - b_max_str) / 2 - b_str, b_str, 0]) Strasse();
	translate([b_basisFiguren - (b_basisFiguren - b_max_str) / 2 - b_str, t_turm - b_str, 0]) Strasse();
	// Straße 5-14
	translate([(b_basisFiguren - b_max_str) / 2, t_turm + t_haus, 0]) Strasse(nx=5);
	translate([b_basisFiguren - (b_basisFiguren - b_max_str) / 2 - b_str_5, t_turm + t_haus, 0]) Strasse(nx=5);
	// letzte Straße
	translate([(b_basisFiguren - t_str) / 2, t_kirche, h_kSchiff]) rotate([0,90,0]) Strasse();
	// dünnen Hohlraum entfernen
	translate([(b_basisFiguren - t_str) / 2, t_turm + t_haus - b_str, h_kSchiff]) rotate([0,90,0]) Strasse();
	// vertikalen Hohlraum ausnehmen
	translate([(b_basisFiguren - t_str) / 2, t_turm + t_haus, t_str - b_str / 2]) rotate([0,90,0]) Strasse(nx=2);
}

module RitterFigurenSchmal(h_box = b_mauer - r_ritter) {
	translate([(2 * b_mauer - h_ritter_6) / 2, 0, h_box - r_ritter]) Ritter(.5);
	translate([0,2 * r_ritter, 0]) Mauer();
	translate([b_mauer, 2 * r_ritter, 0]) Mauer();
	translate([b_mauer / 2, 2 * r_ritter + h_mauer, 0]) Mauer();
}

module RitterFiguren(h_box = b_mauer - r_ritter) {
	translate([h_mauer,0,0]) rotate([0,0,90]) Mauer();
	translate([h_mauer, 0, h_box - r_ritter]) Ritter(margin = 2 * def_margin);
	translate([b_ritterFiguren, 0]) rotate([0,0,90]) Mauer();
	translate([(b_ritterFiguren - b_mauer) / 2, 2 * r_ritter, 0]) Mauer();
	// avoid sharp edges
	translate([(b_ritterFiguren - b_mauer) / 2, 2 * r_ritter + h_mauer - b_mauer, h_box])
		rotate([-90,0,0])
			Mauer();
	translate([(b_ritterFiguren - b_mauer) / 2, 2 * r_ritter + h_mauer - b_mauer, h_box + h_mauer])
		rotate([-90,0,0])
			Mauer();
}

*BasisFiguren();
*RitterFiguren(12);

module HouseAndChurch() {
	difference(){
		union(){
			translate([0, b_kirche, 0]) rotate([0,0,-90]) Kirche(margin=0);
			//translate([t_kirche + t_str * 0.9, 0, 2]) rotate([0,-60,0]) Strasse(margin=0);
			translate([t_kirche + b_str - 2, 2, 2])
			    rotate([90,0,0])
			        linear_extrude(height=2, convexity=5)
			            polygon(points=[[0,0],[b_str*1.2,0],[b_str*3.5, t_str*0.6],[b_str*2.8,t_str*0.6]]);

			translate([ t_kirche + t_str - 2, 0, h_kSchiff]) Haus(margin=0);
		}
		translate([-1, 2, -1]) cube([60, 20, 30]);
	}
}

module Wall(width=15){
	height=0.3 * width;
	space=0.13 * width;
	dx=(width + space) / 2;
	difference() {
		union(){
			for (x = [1:7], y = [0:6]) {
				if (y%2 > 0) {
					translate([x*(width + space) - dx, 0, y*(height + space)]) cube([width, 6, height]);
				} else {
					translate([x*(width + space)     , 0, y*(height + space)]) cube([width, 6, height]);
				}
			}
			translate([0, 0, 6*(height + space)]) cube([width, 6, height]);
		}
		union(){
			translate([6*dx - space, -3, -1]) cube([4*dx + space, 12, 3*height + 2*space + 1]);
			translate([8*dx - space/2,  3, 3*height + 2*space]) rotate([90,0,0]) cylinder(h=12, r=2*dx+space/2, center=true);
		}
		// cut left
		translate([-10 + width + space,-1,0]) cube([10, 8, 5*height + 4*space + 1.1]);
		// cut right
		translate([12*dx + width,-1,-1]) cube([20, 8, 5*height + 4*space + 1.1]);
	}
}

*HouseAndChurch();
*Wall();
