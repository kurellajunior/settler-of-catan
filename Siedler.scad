include <FigurBlocks.scad>;
include <Objects.scad>;
include <box.scad>

rand = 2 + def_margin;
//h_kante = 1.5;
boden = 1.5;
steg = 1;

b_box = b_basisFiguren + 2 * rand;
t_basisBox = 2 * rand + t_turm + t_haus + b_str + def_margin;
h_boxBoden = boden + h_kSchiff + h_haus / 2 - h_kante;
h_boxDeckel= 2 * boden + t_str - h_boxBoden;

module BasisBox() {
	difference() {
		cube([b_box,t_basisBox,h_boxBoden]);
		translate([rand,rand,boden]) BasisFiguren();
	}
	translate([rand / 2, rand / 2, h_boxBoden])
		HalteRahmen(b_box - rand, t_basisBox - rand, h_kante, rand / 2, true);
	// Deckel
	translate([0,-5,h_boxBoden + h_boxDeckel]) rotate(a=180, v=[1,0,0])
		difference() {
			translate([0,0,h_boxBoden]) cube([b_box,t_basisBox,h_boxDeckel]);
			translate([rand,rand,boden]) BasisFiguren();
			translate([rand / 2, rand / 2, h_boxBoden])
				cube([b_box - rand, t_basisBox - rand, h_kante]);
		}
	echo("Breite", b_box, "Tiefe", t_basisBox, "Höhe", h_boxBoden + h_boxDeckel);
}


fn=32;

module RitterBox() {
	t_ritterBox=t_basisBox + steg + 2 * r_ritter + h_mauer;
	x_scale = (b_basisFiguren + 2*def_margin) / (b_ritterFiguren + 2*def_margin);
	// Boden
	difference() {
		BoxBottom(b_box,t_ritterBox,h_boxBoden, rand, rand, 2 * boden, $fn=fn);
		translate([rand,rand,boden]) BasisFiguren();
		translate([rand, t_basisBox - rand + steg, boden])
			scale([x_scale,1,1]) RitterFiguren(h_boxBoden);
		//save some volume
		translate([rand - def_margin , rand - def_margin, h_boxBoden])
			cube([b_basisFiguren + 2*def_margin, t_ritterBox - 2*rand + 2*def_margin, h_haus]);
	}
	translate([0, 2 * t_ritterBox + 5,h_boxBoden + h_boxDeckel]) rotate(a=180, v=[1,0,0])
		difference() {
			translate([0,0,h_boxBoden]) BoxTop(b_box, t_ritterBox, h_boxDeckel, rand, rand, 2 * boden, $fn=fn);
			translate([rand,rand,boden]) BasisFiguren();
			translate([rand, t_basisBox - rand + steg, boden])
				scale([x_scale,1,1]) RitterFiguren(h_boxBoden);
			//save some volume
			translate([(b_basisFiguren - b_kirche_4) / 2 + rand - def_margin, rand - def_margin, h_turm + boden])
				cube([b_kirche_4 + 2*def_margin, t_turm+2*def_margin, t_turm / 3]);
			translate([(b_basisFiguren - b_haus_5) / 2 + rand - def_margin,
						rand+ t_turm - def_margin,
						boden + h_kSchiff + h_haus])
				cube([b_haus_5 + 2*def_margin, t_haus + 2*def_margin, b_haus/3]);
		}
	echo("Breite", b_box, "Tiefe", t_ritterBox, "Höhe", h_boxBoden + h_boxDeckel);
}

*translate([-b_box - 5, 0, 0]) BasisBox();
RitterBox();
