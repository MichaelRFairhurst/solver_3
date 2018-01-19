/**
 * Copyright 2018 Mike and Nathan Fairhurst. See LICENSE for licensing.
 */
include <constants.scad>;
use <util.scad>;
use <snap_joint.scad>;

// Begin config specific to this piece.
thickness = claw_wall_thickness;

// Begin how to print this piece (orientation, etc)
claw();

module claw() {
  difference() {
    translate([cube_size/3/2 + thickness / 2, 0, 0])
      ccube([
        cube_size/3 * 2 + thickness,
        cube_size + thickness * 2,
        cube_size / 3,
      ], x + y + z);
    ccube(cube_size, x + y + z);
  }
  mirrored([y])
    translate([thickness + cube_size/2, -thickness*2, -cube_size/3/2])
    cantilever(thickness*6, cube_size/3, thickness, thickness);
}
