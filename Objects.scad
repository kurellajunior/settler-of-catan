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

*ellipse_prism(10,20,5, $fa=2, $fs=1);
*ellipsoid(10,20,5,false, $fa=2, $fs=0.5);