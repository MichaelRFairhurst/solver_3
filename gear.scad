/**
 * Copyright 2018 Mike and Nathan Fairhurst. See LICENSE for licensing.
 */
include <constants.scad>;
use <util.scad>;

// Begin how to print this piece (orientation, etc)

// Begin modules that can be used to assemble this piece in solver_3.scad
module gear(teeth_size, num_teeth, thickness) {
  circumference = teeth_size * num_teeth;
  radius = circumference / 3.1415 / 2;
  linear_extrude(thickness) {
    circle(radius, $fn=num_teeth);
    for (i=[1:num_teeth]) {
      rotate([0, 0, 360/num_teeth*i]) translate([radius, 0]) circle(teeth_size, $fn=3);
    }
  }
}
