module sphereCut(r, h, center=true) {
	d = 2 * r;
	h_corr = center ? r - h / 2 : r - h;
	translate([0,0,-h_corr])
		difference() {
			sphere(r);
			translate([0, 0, -h]) cube([d, d, d], center = true);
		}
}
* sphereCut(r=10, h=10, center=false);

module ellipse_prism(rx, ry, height, center = true)
{
	dx = center ? 0 : rx;
	dy = center ? 0 : ry;
  	translate([dx,dy,0]) scale([1, ry/rx, 1]) cylinder(h=height, r=rx, center=center);
}

module ellipsoid(rx,ry,rz, center=true){
	scale([1, ry/rx, rz/rx]) sphere(rx);
}

module roundTrapez(x1, x2, y, r){
	$fs=1;
	angle = atan((x1 - x2) / 2 / y); // clockwise around z-achse to reach left edge of trapezoid
	polygon(points=[
		[r                                      , 0],
		[r                                      , r],
		[r - r * cos(angle)                     , r + r * sin(angle)],
		[r - r * cos(angle) + (x1 - x2) / 2     , r + r * sin(angle) + y],
		[r                  + (x1 - x2) / 2     , r                  + y],
		[r                  + (x1 - x2) / 2     , r                  + y + r],
		[r                  + (x1 - x2) / 2 + x2, r                  + y + r],
		[r                  + (x1 - x2) / 2 + x2, r                  + y],
		[r + r * cos(angle) + (x1 - x2) / 2 + x2, r + r * sin(angle) + y],
		[r + r * cos(angle) + x1                , r + r * sin(angle)],
		[r                  + x1                , r],
		[r                  + x1                , 0]
	]);
	if (r > 0) {
		translate([r, r, 0]) circle(r);
		translate([r + (x1 - x2) / 2, r + y, 0]) circle(r);
		translate([r + (x1 - x2) / 2 + x2, r + y,0]) circle(r);
		translate([r + x1, r, 0]) circle(r);
	}
}

module trapez(x1, x2, y) {
	d = (x1 - x2) / 2;
	polygon(points=[
		[0     , 0],
		[d     , y],
		[d + x2, y],
		[x1    , 0]
	]);
}
*ellipse_prism(10,20,5, $fa=2, $fs=1);
*ellipsoid(10,20,5,false, $fa=2, $fs=0.5);