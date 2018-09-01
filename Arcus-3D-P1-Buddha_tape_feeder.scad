// Arcus-3D-P1 -Lego compatible drag feeder OpenSCAD source

// Licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License
// http://creativecommons.org/licenses/by-sa/3.0/

// Project home
// https://hackaday.io/project/160857

// Author
// Daren Schwenke at g mail dot com

// Please like my projects if you find them useful.  Thank you.

//////////////////////////////////////////////////////////////
// Globals
// General clearance, aka, dead space beteen parts for imprecise printing.
clearance=.15;

// Nozzle size for parts only a few widths thick.  Using an even number here ensures better paths for slicer.
nozzle_dia=.3;

// Rendering circle complexity.  Turn down while editing, up while rendering.

// Many things are a multiple of this general wall thickness.
// 1.2mm is magic, as it's both 3*0.4mm or 4*0.3mm
// If you have a different nozzle size and want the best results, keep this in mind.
// Using an even number here generates better paths in slicers.
wall_h=nozzle_dia*4; 

// For differencing so OpenSCAD doesn't freak out
extra=.02;

////////////// do not edit the next two vars //////////////////
// the Lego unit 
u=1.6;
// distance Lego between posts
post_u=u*5; // this is 8mm.

////  Ok... have at it.

// Length of the block
body_l=post_u*6;
 
tape_d=8; // max tape depth
tape_w=8.1;
tape_edge_inset=.6;
tape_hole_inset=2.5;
tape_inset_w=tape_w-tape_hole_inset-tape_edge_inset; 
tape_edge_h=1; // tape edge thickness

peel_l_offset=post_u*1;

pick_l_offset=post_u*4;
pick_l=4;

drag_l_offset=post_u*5;
drag_l=post_u;

base_h=1.6*2+wall_h;
top_h=wall_h; 

body_w=12-clearance;
body_h=base_h+tape_d+top_h;

//////////////////////////////////////////////////////////////
// The parts for rendering
// Uncomment each part here, save, render, then export to STL.

if (0) strip_feeder_pick();
if (0) strip_feeder_peel();
if (0) strip_feeder_combo();
if (0) strip_feeder_cover();
if (0) strip_feeder_fill();
if (1) assembly_view();
if (0) print_all();

module print_all() {
	translate([0,60,0]) strip_feeder_pick();
	translate([0,40,0]) strip_feeder_peel();
	translate([0,20,0]) strip_feeder_combo();
	translate([0,0,0]) strip_feeder_cover();
	translate([0,-15,0]) strip_feeder_fill();
	translate([0,-30,0]) strip_feeder_open();
	translate([0,-48,body_w/2]) strip_feeder_base();
}

module assembly_view() {
	for (i=[1]) translate([body_l*i,0,0]) rotate([90,0,0]) strip_feeder_base();
	//translate([0,0,body_h/2+tape_edge_h+top_h/2+extra]) rotate([180,0,0]) strip_feeder_fill();
	translate([body_l,0,body_h/2+tape_edge_h+top_h/2+extra]) rotate([180,0,0]) strip_feeder_combo();
}

module strip_feeder_base() {
	// modeled on it's side for printing.
	difference() {
		translate([clearance/2,0,0]) cube([body_l-clearance,base_h+tape_d,body_w],center=true);
		// base cutout
		translate([0,-body_h/2-extra,0]) rotate([90,0,0]) lego_base(l=body_l/1.6/5 + 1);
		// lead in
		translate([0,body_h/2-tape_edge_h/12,-body_w/2+tape_edge_inset-tape_w/2]) rotate([270,0,0]) tape_slot();
//for (i=[1,-1]) translate([body_l/2*i+clearance/2,(base_h+tape_d)/2+tape_edge_h/8,0]) rotate([0,0,-15*i]) cube([wall_h*4,tape_edge_h,body_w+extra],center=true);

		// below tape area cutout
		translate([0,base_h/2+extra,body_w/2+tape_edge_inset-(tape_w-tape_hole_inset)/2]) cube([body_l*1.5+extra,tape_d,tape_w-tape_hole_inset+extra],center=true);
		translate([0,body_h/2+tape_edge_h+top_h/2+extra,0]) rotate([90,0,0]) pins(add=clearance);
		// mass cutouts
		for (i=[0:8:body_l-9]) translate([-body_l/2+12+i,base_h/2-wall_h/2+extra,0]) cube([8-wall_h,tape_d-wall_h,body_w+extra],center=true);
		translate([-body_l/2+4+clearance,base_h/2-wall_h/2+extra,0]) cube([8-wall_h,tape_d-wall_h,body_w+extra],center=true);
	}
}

module strip_feeder_pick_base() {
	// modeled on it's side for printing.
	difference() {
		translate([clearance/2,0,0]) cube([body_l-clearance,base_h+tape_d,body_w],center=true);
		// base cutout
		translate([0,-body_h/2-extra,0]) rotate([90,0,0]) lego_base(l=body_l/1.6/5 + 1);
		// lead in
		for (i=[1,-1]) translate([body_l/2*i+clearance/2,(base_h+tape_d)/2+tape_edge_h/8,0]) rotate([0,0,-15*i]) cube([wall_h*4,tape_edge_h,body_w+extra],center=true);

		// below tape area cutout
		translate([0,base_h/2+extra,body_w/2+tape_edge_inset-(tape_w-tape_hole_inset)/2]) cube([body_l*1.5+extra,tape_d,tape_w-tape_hole_inset+extra],center=true);
		translate([0,body_h/2+tape_edge_h+top_h/2+extra,0]) rotate([90,0,0]) pins(add=clearance);
		// mass cutouts
		for (i=[0:8:body_l-9]) translate([-body_l/2+12+i,base_h/2-wall_h/2+extra,0]) cube([8-wall_h,tape_d-wall_h,body_w+extra],center=true);
		translate([-body_l/2+4+clearance,base_h/2-wall_h/2+extra,0]) cube([8-wall_h,tape_d-wall_h,body_w+extra],center=true);
		translate([-body_l/2+pick_l_offset,tape_w/2-tape_hole_inset,-tape_edge_h/2+extra]) hull() { 
			cube([pick_l,tape_w,extra],center=true);
			translate([0,0,-top_h-extra]) cube([pick_l+wall_h,tape_w+wall_h,extra],center=true);
		}
	}
}

module strip_feeder_fill(add=0) {
	difference() {
		union() {
			translate([clearance/2,0,(tape_edge_h+top_h)/2]) cube([body_l-clearance,body_w,tape_edge_h+top_h],center=true);
			pins(add=add);
		}
		translate([0,body_w/2+tape_edge_inset-tape_w/2,top_h+tape_edge_h/2]) {
			tape_slot();
			fill_slot();
		}
	}
}

module strip_feeder_open(add=0) {
	difference() {
		union() {
			translate([clearance/2,0,(tape_edge_h+top_h)/2]) cube([body_l-clearance,body_w,tape_edge_h+top_h],center=true);
			pins(add=add);
		}
		translate([0,body_w/2+tape_edge_inset-tape_w/2,top_h+tape_edge_h/2]) {
			scale([1,1,5]) tape_slot();
		}
	}
}

module strip_feeder_combo(add=0) {
	difference() {
		union() {
			translate([clearance/2,0,(tape_edge_h+top_h)/2]) cube([body_l-clearance,body_w,tape_edge_h+top_h],center=true);
			pins(add=add);
		}
		translate([0,body_w/2+tape_edge_inset-tape_w/2,top_h+tape_edge_h/2]) {
			tape_slot();
			pick_slot();
			peel_slot();
		}
	}
}

module strip_feeder_peel(add=0) {
	difference() {
		union() {
			translate([clearance/2,0,(tape_edge_h+top_h)/2]) cube([body_l-clearance,body_w,tape_edge_h+top_h],center=true);
			pins(add=add);
		}
		translate([0,body_w/2+tape_edge_inset-tape_w/2,top_h+tape_edge_h/2]) {
			tape_slot();
			peel_slot();
		}
	}
}

module strip_feeder_pick(add=0) {
	difference() {
		union() {
			translate([clearance/2,0,(tape_edge_h+top_h)/2]) cube([body_l-clearance,body_w,tape_edge_h+top_h],center=true);
			pins(add=add);
		}
		translate([0,body_w/2+tape_edge_inset-tape_w/2,top_h+tape_edge_h/2]) {
			// tape slot cutout
			tape_slot();
			pick_slot();
		}
	}
}

module strip_feeder_cover(add=0) {
	difference() {
		// body
		union() {
			translate([clearance/2,0,(tape_edge_h+top_h)/2]) cube([body_l-clearance,body_w,tape_edge_h+top_h],center=true);
			pins(add=add);
		}
		translate([0,body_w/2+tape_edge_inset-tape_w/2,top_h+tape_edge_h/2]) {
			tape_slot();
		}
	}
}

module pick_slot(pick_l_offset=pick_l_offset,drag_l_offset=drag_l_offset) {
	// tape slot cutout
	translate([-body_l/2+pick_l_offset,tape_w/2-tape_hole_inset,-tape_edge_h/2+extra]) hull() { 
		cube([pick_l,tape_w,extra],center=true);
		translate([0,0,-top_h-extra]) cube([pick_l+wall_h,tape_w+wall_h,extra],center=true);
	}
	translate([-body_l/2+drag_l_offset,0,-tape_edge_h/2+extra]) hull() { 
		cube([drag_l,tape_w,extra],center=true);
		translate([0,0,-top_h-extra]) cube([drag_l+wall_h,tape_w+wall_h,extra],center=true);
	}
}

module peel_slot(peel_l_offset=peel_l_offset) {
	for (i=[0,1]) translate([0,-i*body_w,0]) {
		cube([body_l+extra,tape_w,tape_edge_h+extra],center=true);
		translate([-body_l/2+peel_l_offset,tape_edge_inset/2,-top_h/2-tape_edge_h/2]) rotate([0,-45,0]) cube([wall_h*4,tape_w-tape_edge_inset,wall_h],center=true);
	}
}

module tape_slot() {
	for (i=[-1,1]) translate([0,-body_w/2-i*body_w/2,0]) {
		cube([body_l+extra,tape_w,tape_edge_h+extra],center=true);
		for (j=[1,-1]) translate([body_l/2*j+clearance/2,0,-tape_edge_h/4]) rotate([0,15*j,0]) cube([wall_h*4,tape_w,tape_edge_h],center=true);
		for (j=[1,-1]) translate([body_l/2*j+clearance/2,tape_w/2*i,0]) intersection() {
			rotate([0,0,90+15*i*j]) cube([tape_edge_h/2,wall_h*4,tape_edge_h*2],center=true);
			rotate([0,15*j,0]) cube([wall_h*4,tape_w,tape_edge_h*1.5],center=true);
		}
	}
}

module fill_slot() {
	for (i=[0,1]) translate([0,-i*body_w,0]) {
		translate([0,tape_hole_inset/4,-tape_edge_h/2+extra]) hull() { 
			cube([body_l,tape_w-tape_hole_inset,extra],center=true);
			translate([0,0,-top_h-extra]) cube([body_l+extra,tape_w-tape_hole_inset+wall_h,extra],center=true);
		}
	}
}

module pins(add=0) {
	for (i=[0:8:body_l-1]) translate([-body_l/2+4+i,-body_w/2+tape_w/2-tape_hole_inset/2,top_h+tape_edge_h+wall_h/2+add/2]) cylinder(r2=wall_h+add,r1=wall_h+2*add,$fn=4,h=wall_h+add+extra,center=true);
}


module lego_base(l=12,w=1,holes=0) {
	// width 1 is actually 2 posts, because I added a third fitting between at half spacing.
	u=1.6; // lego units are 1.6mm.  Everything else is based on that.
	pin=3*u;
	h=2;
	translate([0,0,-h*u]) {
		for (i=[0:1:l]) {
			for (j=[0:1:w*2]) translate([-l*u*5/2+5*u*i,u*5*j/2-2.5*u,h*u/2]) rotate([0,0,22.5]) cylinder(r1=3.25*u/2+clearance,r2=3.25*u/2+clearance/6,h=h*u,$fn=8,center=true);
			translate([-l*u*5/2-2.5*u+5*u*i,0,h*u/2]) cube([.75*u,10*u,h*u],center=true);	
		}
		if (holes) for (i=[0:2:l]) for (j=[w]) translate([-l*u*5/2+5*u*i,u*5*j/2-2.5*u,-h*u]) rotate([0,0,22.5]) cylinder(r=3*u/2+clearance/6,h=h*u*2+extra*2,center=true);
	}
}
