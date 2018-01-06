/**
 * Copyright 2018 Mike and Nathan Fairhurst. See LICENSE for licensing.
 */
include <constants.scad>;
use <util.scad>;
use <cube_holder.scad>;
use <arm.scad>;

thickness = 4;
width = 20;
height_at_front = 70;
height_at_back = 90;
cube_to_arm_gap = 40;
cube_to_arm_len = 60;

// Begin how to print this piece (orientation, etc)
rotate([90, 0, 0]) frame();

// Begin modules that can be used to assemble this piece in solver_3.scad

module above_frame() {
  up(thickness) children();
}

module frame() {
  difference() {
    union() {
      translate([-width/2, 0, 0])
        ccube([cube_to_arm_len + width/2, width, thickness], y);
      translate([cube_to_arm_gap, 0, 0])
        ccube([thickness, width, height_at_front], y);
      translate([cube_to_arm_len, 0, 0])
        ccube([thickness, width, height_at_back], y);
    }
    above_cube_holder() onto_point(cube_size) arm($fn=100);
  }
}
