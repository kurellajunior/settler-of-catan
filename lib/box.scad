include <Objects.scad>

h_kante = 2;
printer_delta = 0.05;

module HalteRahmen(breite, tiefe, h, dx, dy, delta=0) {
	d = max(dx,dy);
	difference() {
		translate([-delta/2, -delta/2, 0]) cube([breite+delta, tiefe+delta, h]);
		translate([-delta/2, -delta/2, h/2]) rotate([0,0,45]) cube([d,d,h], center=true);
		translate([breite+delta/2, -delta/2, h/2]) rotate([0,0,45]) cube([d,d,h], center=true);
		translate([breite+delta/2, tiefe+delta/2, h/2]) rotate([0,0,45]) cube([d,d,h], center=true);
		translate([-delta/2, tiefe+delta/2, h/2]) rotate([0,0,45]) cube([d,d,h], center=true);
	}
}


module HalfBox(x, y, z, rx, ry, rz) {
	innerX = x - 2 * rx;
	innerY = y - 2 * ry;
	translate([ 0, ry, rz]) cube([x, innerY, z - rz]);
	translate([rx,  0, rz]) cube([innerX, y, z - rz]);
	translate([rx, ry,  0]) cube([innerX, innerY, z]);
	// bottom cylinders
	translate([ rx + innerX/2, ry, rz]) rotate([0,90,0]) ellipse_prism(rx = rz, ry = ry, height = innerX);
	translate([ rx + innerX/2, ry + innerY, rz]) rotate([0,90,0]) ellipse_prism(rx = rz, ry = ry, height = innerX);
	translate([ rx, ry + innerY/2, rz]) rotate([90,0,0]) ellipse_prism(rx = rx, ry = rz, height = innerY);
	translate([ rx + innerX, ry + innerY/2, rz]) rotate([90,0,0]) ellipse_prism(rx = rx, ry = rz, height = innerY);
	// corner
	for (x = [rx, rx+innerX], y = [ry, ry+innerY]) {
		translate([x, y, (z+rz)/2]) ellipse_prism(rx = rx, ry = ry, height = z - rz);
		translate([x, y, rz]) ellipsoid(rx, ry,rz);
	}
}

module FullBoxBottom(x, y, z, rx, ry, rz) {
	HalfBox(x, y, z, rx, ry, rz);
	translate([rx / 2, ry / 2, z]) HalteRahmen(x - rx, y - ry, h_kante, rx/2, ry/2, delta = -printer_delta);
}

module BoxBottom(x, y, z, rx=2, ry=2, rz=2, empty=false) {
	if (empty) {
		difference() {
			FullBoxBottom(x, y, z, rx, ry, rz);
			translate([rx,ry,rz]) cube([x - 2 * rx, y - 2 * ry, z + h_kante]);
		}
	} else {
			FullBoxBottom(x, y, z, rx, ry, rz);
	}
}

// Deckel
module BoxTop(x, y, z, rx=2, ry=2, rz=2, empty=false) {
	difference() {
		translate([0, y, z]) rotate([180,0,0]) HalfBox(x, y, z, rx, ry, rz);
		if (empty) {
			translate([rx,ry,0]) cube([x - 2 * rx, y - 2 * ry,z - rz]);
		}
		translate([rx / 2, ry / 2, 0]) HalteRahmen(x - rx, y - ry, h_kante, rx/2, ry/2, delta = printer_delta);
	}
}


/*
module emptyBox(x, y, z_bottom, z_top, rx=2, ry=2, rz=2) {
	BoxBottom(x, y, z_bottom, rx, ry, rz, empty=true);
	translate([0,-5,z_top]) rotate([180,0,0]) BoxTop(x, y, z_top, rx, ry, rz, empty=false);
}

emptyBox(40, 30, 12, 8, 2.5, 2.5, 2, 	$fn=32);
BoxTop(40, 30, 8, 2.5, 2.5, 2, 	$fn=32);
*/
