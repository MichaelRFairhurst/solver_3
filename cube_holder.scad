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
  up(servo_gear_thickness) above_frame() children();
}

module cube_holder() {
  up(servo_gear_thickness) onto_point()
    piece_sleeve();
  holder_gear();
}

module piece_sleeve() {
  piece_size = cube_size / 3 + margin;
  holder_open_size = piece_size + thickness;
  holder_closed_size = piece_size + thickness + embedded_thickness;
  translate([-piece_size/2,piece_size/2,piece_size/2]) {
    difference() {
      translate([thickness/2, (embedded_thickness-thickness)/2, (embedded_thickness-thickness)/2])
        ccube([holder_open_size, holder_closed_size, holder_closed_size], x+y+z);
      rounded_cube(piece_size, cube_rounding, x+y+z);
      translate([-thickness, 0, 0]) rounded_cube(piece_size, cube_rounding, x+y+z);
      rotate(45,[1,0,1])
        translate([0,holder_open_size,0])
        ccube([holder_open_size, holder_closed_size, holder_closed_size], x+y+z);
    }
    translate([(piece_size + thickness)/2,-(piece_size/2 + thickness),(piece_size + thickness)/-2])
      rotate(90,[1,0,0])
      rotate(22.5,[0,0,1])
      pin(thickness*2.5,thickness/2);
  }
}

module holder_gear() {
  difference() {
    gear(servo_gear_teeth_size, servo_gear_num_teeth*4, servo_gear_thickness);
    up(servo_gear_thickness) onto_point() piece_sleeve();
  }
}
