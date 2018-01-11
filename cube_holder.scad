/**
 * Copyright 2018 Mike and Nathan Fairhurst. See LICENSE for licensing.
 */
include <constants.scad>;
use <util.scad>;
use <frame.scad>;
use <gear.scad>;

// Begin config specific to this piece.
margin = 0.5;
thickness = 2.5;
embedded_thickness = 1;

// Begin how to print this piece (orientation, etc)
cube_holder();

// Begin modules that can be used to assemble this piece in solver_3.scad

module above_cube_holder() {
  up(thickness/2 + servo_gear_thickness) above_frame() children();
}

module cube_holder() {
  piece_size = cube_size / 3 + margin;
  holder_open_size = piece_size + thickness;
  holder_closed_size = piece_size + thickness + embedded_thickness;
  difference() {
    up(servo_gear_thickness - thickness/2)
      onto_point(holder_closed_size)
      difference() {
        ccube([holder_open_size, holder_closed_size, holder_closed_size], x+y+z);
        translate([-thickness/2, thickness/2, thickness/2]) {
          rounded_cube(piece_size, cube_rounding, x+y+z);
          translate([-thickness, 0, 0]) rounded_cube(piece_size, cube_rounding, x+y+z);
          //translate([-cube_rounding, cube_rounding, cube_rounding]) ccube(piece_size, x+y+z);
        }
    }
    up(piece_size * 2) ccube(piece_size * 3, x + y);
  }
  holder_gear();
}

module holder_gear() {
  gear(servo_gear_teeth_size, servo_gear_num_teeth*2, servo_gear_thickness);
}
