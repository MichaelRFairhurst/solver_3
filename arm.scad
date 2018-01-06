/**
 * Copyright 2018 Mike and Nathan Fairhurst. See LICENSE for licensing.
 */
include <constants.scad>;
use <util.scad>;

// Begin config specific to this piece.
arm_length = 70;
width = 4;
grip_width = 2;

// Begin how to print this piece (orientation, etc)
rotate([0, 90, 0]) arm();

// Begin modules that can be used to assemble this piece in solver_3.scad
module arm() {
  rotate([0, 270, 0]) {
    translate([0, 0, cube_size/2]) cylinder(d=width, arm_length);
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

