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
  translate([-piece_size/2,piece_size/2,piece_size/2]) {
    difference() {
      translate([thickness/2, (embedded_thickness-thickness)/2, (embedded_thickness-thickness)/2])
        ccube([holder_open_size, holder_closed_size, holder_closed_size], x+y+z);
      if (hollow) {
        rounded_cube(piece_size, cube_rounding, x+y+z);
        translate([-thickness, 0, 0]) rounded_cube(piece_size, cube_rounding, x+y+z);
        onto_point()
          translate([0, 0, holder_closed_size])
          ccube(holder_open_size, x+y+z);
      }
    }
  }
  pin_radius = thickness/2;
  translate([thickness - pin_radius, 0, -thickness])
    rotate(90, x) // rotate the pin so it prints flat
    rotate(90, z) // turn the pin so that it lays on a face
    pin(thickness*9/4, pin_radius);
}
