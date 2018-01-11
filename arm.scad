/**
 * Copyright 2018 Mike and Nathan Fairhurst. See LICENSE for licensing.
 */
include <constants.scad>;
use <util.scad>;
use <gear.scad>;

// Begin config specific to this piece.
arm_length = 100;
width = 8;
grip_width = 2;
extend_retract_gear_size = 1;

// Begin how to print this piece (orientation, etc)
rotate([0, 90, 0]) arm();

// Begin modules that can be used to assemble this piece in solver_3.scad
module arm() {
  rotate([0, 270, 0]) {
    translate([0, 0, cube_size/2])
      opposing_gears(arm_length, width, extend_retract_gear_size);
      //cylinder(d=width, arm_length);
    difference() {
      translate([0, 0, cube_size/3/2 + grip_width / 2])
        ccube([
          cube_size + grip_width * 2,
          cube_size / 3,
          cube_size/3 * 2 + grip_width
        ], x + y + z);
      ccube(cube_size, x + y + z);
    }
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
