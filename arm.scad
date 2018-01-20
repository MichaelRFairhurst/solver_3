/**
 * Copyright 2018 Mike and Nathan Fairhurst. See LICENSE for licensing.
 */
include <constants.scad>;
use <util.scad>;
use <gear.scad>;
use <snap_joint.scad>;

// Begin config specific to this piece.
arm_length = 100;
width = 20;
cantilever_thickness = claw_wall_thickness;
extend_retract_gear_size = 1;

// Begin how to print this piece (orientation, etc)
rotate(270, y) arm();

// Begin modules that can be used to assemble this piece in solver_3.scad
module arm(include_gears=true) {
  cantilever_height = cantilever_thickness*6;
  difference() {
    union() {
      rotate([0, 90, 0]) {
        if (include_gears)
          opposing_gears(arm_length, width, extend_retract_gear_size);
        else cylinder(d=width, arm_length);
      }
      ccube([cantilever_thickness + cantilever_height, width, cantilever_thickness*2 + cube_size/3], y+z);
    }
    up(-cube_size/3/2)
      mirrored([y])
      translate([0, -cantilever_thickness*2, 0])
      cantilever_negative(cantilever_height, cube_size/3, cantilever_thickness, cantilever_thickness);
  }
}

module opposing_gears(length, width, extend_retract_gear_size) {
  intersection() {
    fixed_outer_size_gear(width, 10, length);
    ccube([width, width, length], y);
  }
  difference() {
    movable_cylinder(extend_retract_gear_size, width, length);
    ccube([width, width, length], y);
  }
}

module movable_cylinder(teeth_size = 1, width = width, length=arm_length) {
  iters = floor(length / teeth_size);

  radial_offset = gear_tooth_additional_radius(teeth_size) + teeth_size /2;

  intersection() {
    // restrict to the actual length
    ccube([width, width, length], x+y);
    // each tooth
    for (i=[0:iters]) {
      up(i * teeth_size)
      rotate_extrude()
      translate([width / 2 - radial_offset, 0, 0])
      circle(teeth_size, $fn=3);
    }
  }

  // without this its hollow
  cylinder(r=width / 2 - radial_offset, h=length);
}
