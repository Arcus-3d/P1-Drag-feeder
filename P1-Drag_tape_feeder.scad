// Arcus-3D-P1 -Lego compatible drag feeder OpenSCAD source

// Licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License
// http://creativecommons.org/licenses/by-sa/3.0/

// Project home
// https://hackaday.io/project/160857

// Author
// Daren Schwenke at g mail dot com

// Please like my projects if you find them useful.  Thank you.

// global, to become constant, for command line rendering.
print = false;
//print = "combo";
length = 6; // Length in mm =  8 * length 
depth = 8;
width = 8;
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
block_l=post_u*length;
 
tape_d=depth;
tape_w=width + clearance;
tape_edge_inset=.6;
tape_hole_inset=2.5;
tape_inset_w=tape_w-tape_hole_inset-tape_edge_inset; 
tape_edge_h=1; // tape edge thickness

peel_l_offset=block_l/6;

pick_l_offset=block_l-post_u*2;
pick_l=4;

drag_l_offset=pick_l_offset+post_u*1.5;
drag_l=8;

base_h=1.6*2+wall_h;
top_h=wall_h; 

block_w=12-clearance;
block_h=base_h+tape_d+top_h;

//////////////////////////////////////////////////////////////
// The parts for rendering

print_this = print;
//print_this = "all";
if (print_this == "base") translate([0,0,block_w/2]) strip_feeder_base();
if (print_this == "pick") strip_feeder_pick();
if (print_this == "peel") strip_feeder_peel();
if (print_this == "combo") strip_feeder_combo();
if (print_this == "cover") strip_feeder_cover();
if (print_this == "fill") strip_feeder_fill();
if (print_this == "open") strip_feeder_open();
if (print_this == "all" ) print_all();

if (0) assembly_view();

module print_all() {
	translate([0,60,0]) strip_feeder_pick();
	translate([0,40,0]) strip_feeder_peel();
	translate([0,20,0]) strip_feeder_combo();
	translate([0,0,0]) strip_feeder_cover();
	translate([0,-15,0]) strip_feeder_fill();
	translate([0,-30,0]) strip_feeder_open();
	translate([0,-48,block_w/2]) strip_feeder_base();
}

module assembly_view() {
	translate([0,0,block_h/2+tape_edge_h+top_h/2+extra]) rotate([180,0,0]) strip_feeder_pick();
	translate([0,0,0]) rotate([90,0,0]) strip_feeder_base();
	translate([0,block_w,block_h/2+tape_edge_h+top_h/2+extra]) rotate([180,0,0]) strip_feeder_combo();
	translate([-post_u*6,block_w,block_h/2+tape_edge_h+top_h/2+extra]) rotate([180,0,0]) strip_feeder_cover();
	translate([-post_u*3,block_w,0]) rotate([90,0,0]) strip_feeder_base(l=post_u*12);
}

module strip_feeder_base(l=block_l,w=block_w) {
	// modeled on it's side for printing.
	difference() {
		translate([clearance/2,0,0]) cube([l-clearance,base_h+tape_d,w],center=true);
		// base cutout
		translate([0,-block_h/2-extra,0]) rotate([90,0,0]) lego_base(l=l/1.6/5 + 1);
		// lead in
		translate([0,block_h/2-tape_edge_h/12,-w/2+tape_edge_inset-tape_w/2]) rotate([270,0,0]) tape_slot(l=l);
		// below tape area cutout
		translate([0,base_h/2+extra,w/2+tape_edge_inset-(tape_w-tape_hole_inset)/2]) cube([l*1.5+extra,tape_d,tape_w-tape_hole_inset+extra],center=true);
		translate([0,block_h/2+tape_edge_h+top_h/2+extra,0]) rotate([90,0,0]) pins(l=l,add=clearance);
		// mass cutouts
		for (i=[0:8:l-9]) translate([-l/2+12+i,base_h/2-wall_h/2+extra,0]) cube([8-wall_h,tape_d-wall_h,w+extra],center=true);
		translate([-l/2+4+clearance,base_h/2-wall_h/2+extra,0]) cube([8-wall_h,tape_d-wall_h,w+extra],center=true);
	}
}

module strip_feeder_pick_base(l=block_l,w=block_w) {
	// modeled on it's side for printing.
	difference() {
		translate([clearance/2,0,0]) cube([l-clearance,base_h+tape_d,w],center=true);
		// base cutout
		translate([0,-block_h/2-extra,0]) rotate([90,0,0]) lego_base(l=l/1.6/5 + 1);
		// lead in
		translate([0,block_h/2-tape_edge_h/12,-w/2+tape_edge_inset-tape_w/2]) rotate([270,0,0]) tape_slot(l=l);
		// below tape area cutout
		translate([0,base_h/2+extra,w/2+tape_edge_inset-(tape_w-tape_hole_inset)/2]) cube([l*1.5+extra,tape_d,tape_w-tape_hole_inset+extra],center=true);
		translate([0,block_h/2+tape_edge_h+top_h/2+extra,0]) rotate([90,0,0]) pins(l=l,add=clearance);
		// mass cutouts
		for (i=[0:8:l-9]) translate([-l/2+12+i,base_h/2-wall_h/2+extra,0]) cube([8-wall_h,tape_d-wall_h,w+extra],center=true);
		translate([-l/2+4+clearance,base_h/2-wall_h/2+extra,0]) cube([8-wall_h,tape_d-wall_h,w+extra],center=true);
		translate([-l/2+pick_l_offset,tape_w/2-tape_hole_inset,-tape_edge_h/2+extra]) hull() { 
			cube([pick_l,tape_w,extra],center=true);
			translate([0,0,-top_h-extra]) cube([pick_l+wall_h,tape_w+wall_h,extra],center=true);
		}
	}
}

module strip_feeder_fill(l=block_l,w=block_w) {
	difference() {
		union() {
			translate([clearance/2,0,(tape_edge_h+top_h)/2]) cube([l-clearance,w,tape_edge_h+top_h],center=true);
			pins(l=l);
		}
		translate([0,w/2+tape_edge_inset-tape_w/2,top_h+tape_edge_h/2]) {
			tape_slot(l=l);
			fill_slot(l=l);
		}
	}
}

module strip_feeder_open(l=block_l,w=block_w) {
	difference() {
		union() {
			translate([clearance/2,0,(tape_edge_h+top_h)/2]) cube([l-clearance,w,tape_edge_h+top_h],center=true);
			pins(l=l);
		}
		translate([0,w/2+tape_edge_inset-tape_w/2,top_h+tape_edge_h/2]) {
			scale([1,1,5]) tape_slot();
		}
	}
}

module strip_feeder_combo(l=block_l,w=block_w) {
	difference() {
		union() {
			translate([clearance/2,0,(tape_edge_h+top_h)/2]) cube([l-clearance,w,tape_edge_h+top_h],center=true);
			pins(l=l);
		}
		translate([0,w/2+tape_edge_inset-tape_w/2,top_h+tape_edge_h/2]) {
			tape_slot(l=l);
			pick_slot(l=l);
			peel_slot(l=l);
		}
	}
}

module strip_feeder_peel(l=block_l,w=block_w) {
	difference() {
		union() {
			translate([clearance/2,0,(tape_edge_h+top_h)/2]) cube([l-clearance,w,tape_edge_h+top_h],center=true);
			pins(l=l);
		}
		translate([0,w/2+tape_edge_inset-tape_w/2,top_h+tape_edge_h/2]) {
			tape_slot(l=l);
			peel_slot(l=l);
		}
	}
}

module strip_feeder_pick(l=block_l,w=block_w) {
	difference() {
		union() {
			translate([clearance/2,0,(tape_edge_h+top_h)/2]) cube([l-clearance,w,tape_edge_h+top_h],center=true);
			pins(l=l);
		}
		translate([0,w/2+tape_edge_inset-tape_w/2,top_h+tape_edge_h/2]) {
			// tape slot cutout
			tape_slot(l=l);
			pick_slot(l=l);
		}
	}
}

module strip_feeder_cover(l=block_l,w=block_w,add=0) {
	difference() {
		// body
		union() {
			translate([clearance/2,0,(tape_edge_h+top_h)/2]) cube([l-clearance,w,tape_edge_h+top_h],center=true);
			pins(l=l);
		}
		translate([0,w/2+tape_edge_inset-tape_w/2,top_h+tape_edge_h/2]) {
			tape_slot(l=l);
		}
	}
}

module pick_slot(l=block_l,w=block_w,pick_l_offset=pick_l_offset,drag_l_offset=drag_l_offset) {
	// tape slot cutout
	translate([-l/2+pick_l_offset,tape_w/2-tape_hole_inset,-tape_edge_h/2+extra]) hull() { 
		cube([pick_l,tape_w,extra],center=true);
		translate([0,0,-top_h-extra]) cube([pick_l+wall_h,tape_w+wall_h,extra],center=true);
	}
	translate([-l/2+drag_l_offset,0,-tape_edge_h/2+extra]) hull() { 
		cube([drag_l,tape_w,extra],center=true);
		translate([0,0,-top_h-extra]) cube([drag_l+wall_h,tape_w+wall_h,extra],center=true);
	}
}

module peel_slot(l=block_l,w=block_w,peel_l_offset=peel_l_offset) {
	for (i=[0,1]) translate([0,-i*w,0]) {
		cube([l+extra,tape_w,tape_edge_h+extra],center=true);
		translate([-l/2+peel_l_offset,tape_edge_inset/2,-top_h/2-tape_edge_h/2]) rotate([0,-45,0]) cube([wall_h*4,tape_w-tape_edge_inset,wall_h],center=true);
	}
}

module tape_slot(l=block_l,w=block_w) {
	for (i=[-1,1]) translate([0,-w/2-i*w/2,0]) {
		cube([l+extra,tape_w,tape_edge_h+extra],center=true);
		for (j=[1,-1]) translate([l/2*j+clearance/2,0,-tape_edge_h/4]) rotate([0,15*j,0]) cube([wall_h*4,tape_w,tape_edge_h],center=true);
		for (j=[1,-1]) translate([l/2*j+clearance/2,tape_w/2*i,0]) intersection() {
			rotate([0,0,90+15*i*j]) cube([tape_edge_h/2,wall_h*4,tape_edge_h*2],center=true);
			rotate([0,15*j,0]) cube([wall_h*4,tape_w,tape_edge_h*1.5],center=true);
		}
	}
}

module fill_slot(l=block_l,w=block_w) {
	for (i=[0,1]) translate([0,-i*w,0]) {
		translate([0,tape_hole_inset/4,-tape_edge_h/2+extra]) hull() { 
			cube([l,tape_w-tape_hole_inset,extra],center=true);
			translate([0,0,-top_h-extra]) cube([l+extra,tape_w-tape_hole_inset+wall_h,extra],center=true);
		}
	}
}

module pins(l=block_l,w=block_w,add=0) {
	for (i=[0:8:l-1]) translate([-l/2+4+i,-w/2+tape_w/2-tape_hole_inset/2,top_h+tape_edge_h+wall_h/2+add/2]) cylinder(r2=wall_h+add,r1=wall_h+1.5*add,$fn=4,h=wall_h+add+extra,center=true);
}


module lego_base(l=12,w=1,holes=0) {
	// width 1 is actually 2 posts, because I added a third fitting between at half spacing.
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

