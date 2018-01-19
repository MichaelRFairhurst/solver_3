/**
 * Copyright 2018 Mike and Nathan Fairhurst. See LICENSE for licensing.
 */
include <constants.scad>;
use <util.scad>;
use <frame.scad>;
use <pin.scad>;

// Begin config specific to this piece.
margin = 0.5;
thickness = 2.5;
embedded_thickness = 1;

// Begin how to print this piece (orientation, etc)
cube_holder();

// Begin modules that can be used to assemble this piece in solver_3.scad

module above_cube_holder() {
  up(servo_gear_thickness) above_frame() children();
}

module cube_holder(hollow=true) {
  piece_size = cube_size / 3 + margin;
  holder_open_size = piece_size + thickness;
  holder_closed_size = piece_size + thickness + embedded_thickness;
  arbitrary_corner_cut = holder_open_size*5/4;
  difference() {
    translate([-piece_size - embedded_thickness, -thickness, -thickness])
      cube([holder_closed_size, holder_closed_size, holder_open_size]);
    if (hollow) {
      translate([cube_rounding - piece_size, cube_rounding, cube_rounding]) {
        // this cube is the negative of the cubie that will be inserted
        rounded_cube(piece_size, cube_rounding);
        // this cube makes sure that there is a clean hole for the cubie to enter
        translate([0, 0, cube_rounding])
          rounded_cube(piece_size, cube_rounding);
      }
      rotate(45, x+y)
        rotate(45, z)
        translate([0,arbitrary_corner_cut,0])
        ccube(holder_open_size*2, x+z);
    }
  }
  pin_radius = thickness;
  translate([thickness - pin_radius, 0, -thickness])
    rotate(90, x) // rotate the pin so it prints flat
    rotate(90, z) // turn the pin so that it lays on a face
    pin(thickness*2.5, pin_radius);
}
