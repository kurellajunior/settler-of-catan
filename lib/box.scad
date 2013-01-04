include <Objects.scad>

h_kante = 2;
printer_delta = 0.05;

module HalteRahmen(breite, tiefe, h, d) {
	delta = -printer_delta;
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

module BoxBottom(x, y, z, rx=2, ry=2, rz=2) {
	HalfBox(x, y, z, rx, ry, rz);
	translate([rx / 2, ry / 2, z]) HalteRahmen(x - rx, y - ry, h_kante, d = max(rx/2, ry/2));
}

// Deckel
module BoxTop(x, y, z, rx=2, ry=2, rz=2) {
	difference() {
		translate([0, y, z]) rotate([180,0,0]) HalfBox(x, y, z, rx, ry, rz);
		translate([rx / 2, ry / 2, 0]) HalteRahmen(x - rx, y - ry, h_kante, d = max(rx/2, ry/2));
	}
}


module HalfTrapezoid(x1, x2, y, z, r) {
	$fs=1;
	angle = atan((x1 - x2) / 2 / y); // counter clockwise around z-achse to reach left edge of trapezoid
    linear_extrude(height=z)
		roundTrapez(x1,x2,y,r);
	if (r > 0) {
	    translate([r,r,-r])
		    linear_extrude(height=r)
				trapez(x1,x2,y);
		// bottom cylinders
		translate([r, r, 0]) rotate([0,90,0]) cylinder(r = r, h = x1);
		translate([r + (x1 - x2) / 2, r + y, 0]) rotate([0,90,0]) cylinder(r = r, h = x2);
		translate([r, r, 0]) rotate([0,0,-angle]) rotate([-90,0,0]) cylinder(r = r, h = y / cos(angle));
		translate([r + x1, r, 0]) rotate([0,0, angle]) rotate([-90,0,0]) cylinder(r = r, h = y / cos(angle));
		// corners
		translate([r, r, 0]) sphere(r);
		translate([r + (x1 - x2) / 2, r + y, 0]) sphere(r);
		translate([r + (x1 - x2) / 2 + x2, r + y, 0]) sphere(r);
		translate([r + x1, r, 0]) sphere(r);
	}
}

//HalfTrapezoid(40, 30, 20, 15, 4);
/*
BoxTop(40, 30, 8, 2.5, 2.5, 2, $fn=32);
*/
