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


module HalfBox(x, y, z, dx, dy, dz) {
	innerX = x - 2 * dx;
	innerY = y - 2 * dy;
	translate([ 0, dy, dz]) cube([x, innerY, z - dz]);
	translate([dx,  0, dz]) cube([innerX, y, z - dz]);
	translate([dx, dy,  0]) cube([innerX, innerY, z]);
	// bottom cylinders
	translate([ dx + innerX/2, dy, dz]) rotate([0,90,0]) ellipse_prism(rx = dz, ry = dy, height = innerX);
	translate([ dx + innerX/2, dy + innerY, dz]) rotate([0,90,0]) ellipse_prism(rx = dz, ry = dy, height = innerX);
	translate([ dx, dy + innerY/2, dz]) rotate([90,0,0]) ellipse_prism(rx = dx, ry = dz, height = innerY);
	translate([ dx + innerX, dy + innerY/2, dz]) rotate([90,0,0]) ellipse_prism(rx = dx, ry = dz, height = innerY);
	// corner
	for (x = [dx, dx+innerX], y = [dy, dy+innerY]) {
		translate([x, y, (z+dz)/2]) ellipse_prism(rx = dx, ry = dy, height = z - dz);
		translate([x, y, dz]) ellipsoid(dx, dy,dz);
	}
}

module FullBoxBottom(x, y, z, dx, dy, dz) {
	HalfBox(x, y, z, dx, dy, dz);
	translate([dx / 2, dy / 2, z]) HalteRahmen(x - dx, y - dy, h_kante, dx/2, dy/2, delta = -printer_delta);
}

module BoxBottom(x, y, z, dx=2, dy=2, dz=2, empty=false) {
	if (empty) {
		difference() {
			FullBoxBottom(x, y, z, dx, dy, dz);
			translate([dx,dy,dz]) cube([x - 2 * dx, y - 2 * dy, z + h_kante]);
		}
	} else {
			FullBoxBottom(x, y, z, dx, dy, dz);
	}
}

// Deckel
module BoxTop(x, y, z, dx=2, dy=2, dz=2, empty=false) {
	difference() {
		translate([0, y, z]) rotate([180,0,0]) HalfBox(x, y, z, dx, dy, dz);
		if (empty) {
			translate([dx,dy,0]) cube([x - 2 * dx, y - 2 * dy,z - dz]);
		}
		translate([dx / 2, dy / 2, -1]) HalteRahmen(x - dx, y - dy, h_kante + 1, dx/2, dy/2, delta = printer_delta);
	}
}


/*
module emptyBox(x, y, z_bottom, z_top, dx=2, dy=2, dz=2) {
	BoxBottom(x, y, z_bottom, dx, dy, dz, empty=true);
	translate([0,-5,z_top]) rotate([180,0,0]) BoxTop(x, y, z_top, dx, dy, dz, empty=false);
}

emptyBox(40, 30, 12, 8, 2.5, 2.5, 2, 	$fn=32);
BoxTop(40, 30, 8, 2.5, 2.5, 2, 	$fn=32);
*/
