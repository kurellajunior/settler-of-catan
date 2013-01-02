include <Figuren.scad>

b_kirche_4 = 4 * b_kirche;
b_haus_5   = 5 * b_haus;
b_str_5    = 5 * b_str;
b_str_5_2  = 2 * b_str_5 + 1;
b_4k_2s    = 2 * b_str + b_kirche_4;
h_ritter_6 = 6 * h_ritter;

b_basisFiguren  = max(b_haus_5, max(b_str_5_2, b_4k_2s));
b_ritterFiguren = h_ritter_6 + 2 * h_mauer;

module BasisFiguren(){
	// Kirchen
	translate([(b_basisFiguren - b_kirche_4) / 2, 0, 0]) Kirche(width = b_kirche_4);
	// Houses
	translate([(b_basisFiguren - b_haus_5) / 2, t_turm, h_kSchiff]) Haus(nx=5);
	// Straße 1-4
	translate([(b_basisFiguren - b_4k_2s) / 2, 0,     0]) Strasse();
	translate([(b_basisFiguren - b_4k_2s) / 2, b_str, 0]) Strasse();
	translate([(b_basisFiguren - b_4k_2s) / 2, t_turm - b_str, 0]) Strasse();
	translate([b_basisFiguren - (b_basisFiguren - b_4k_2s) / 2 - b_str, 0,     0]) Strasse();
	translate([b_basisFiguren - (b_basisFiguren - b_4k_2s) / 2 - b_str, b_str, 0]) Strasse();
	translate([b_basisFiguren - (b_basisFiguren - b_4k_2s) / 2 - b_str, t_turm - b_str, 0]) Strasse();
	// Straße 5-14
	translate([(b_basisFiguren - b_4k_2s) / 2, t_turm + t_haus, 0]) Strasse(nx=5);
	translate([b_basisFiguren - (b_basisFiguren - b_4k_2s) / 2 - b_str_5, t_turm + t_haus, 0]) Strasse(nx=5);
	// letzte Straße
	translate([(b_basisFiguren - t_str) / 2, t_kirche, h_kSchiff]) rotate([0,90,0]) Strasse();
	// dünnen Hohlraum entfernen
	translate([(b_basisFiguren - t_str) / 2, t_turm + t_haus - b_str, h_kSchiff]) rotate([0,90,0]) Strasse();
	// vertikalen Hohlraum ausnehmen
	translate([(b_basisFiguren - t_str) / 2, t_turm + t_haus, t_str - b_str / 2]) rotate([0,90,0]) Strasse(nx=3);
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
	translate([2 * h_mauer + h_ritter_6, 0]) rotate([0,0,90]) Mauer();
	translate([(2 * h_mauer + h_ritter_6 - b_mauer) / 2, 2 * r_ritter, 0]) Mauer();
}

*BasisFiguren();
*RitterFiguren(12);
