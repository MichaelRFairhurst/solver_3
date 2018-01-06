/**
 * Copyright 2018 Mike and Nathan Fairhurst. See LICENSE for licensing.
 */
include <constants.scad>;
use <util.scad>;
use <frame.scad>;

// Begin config specific to this piece.
thickness = 2;

// Begin how to print this piece (orientation, etc)
holder();

// Begin modules that can be used to assemble this piece in solver_3.scad

module above_cube_holder() {
  up(thickness) above_frame() children();
}

module cube_holder(cube_size=cube_size) {
  holder_size = cube_size / 3;
  difference() {
    cube_on_point(holder_size) cube(holder_size, center=true);
    up(thickness) cube_on_point(holder_size) cube(holder_size, center=true);
  }
}
