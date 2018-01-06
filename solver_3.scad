/**
 * Copyright 2018 Mike and Nathan Fairhurst. See LICENSE for licensing.
 */
include <constants.scad>;
use <util.scad>;
use <rubiks_cube.scad>;
use <cube_holder.scad>;
use <frame.scad>;
use <arm.scad>;

// This file is for previewing everything at once. All logic related
// to piece placement & arrangement belongs here; however, any logic
// related to the shape of a piece should be in its own file, one
// per printable piece in most cases.

above_cube_holder() {
  rubiks_cube_on_point();
  onto_point(cube_size) arm();
}

above_frame() cube_holder();

frame();
