/**
 * Copyright 2018 Mike and Nathan Fairhurst. See LICENSE for licensing.
 */
include <constants.scad>;
use <util.scad>;

// Begin config specific to this piece.
// nothing

// Begin how to print this piece (orientation, etc)
// nothing: doesn't print.

// Begin modules that can be used to assemble this piece in solver_3.scad

module rubiks_cube_on_point(size=cube_size, rounding=1) {
  onto_point(size) rubiks_cube(size, rounding);
}

module rubiks_cube(size = 10, rounding=1) {
  piece_size = size / 3;
  for(r = [-1:1]) {
    for(c = [-1:1]) {
      for(l = [-1:1]) {
        translate([r*piece_size, c*piece_size, l*piece_size]) 
          rounded_cube(piece_size, rounding, center=x+y+z);
      }
    }
  }
}
