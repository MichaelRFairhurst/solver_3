/**
 * Copyright 2018 Mike and Nathan Fairhurst. See LICENSE for licensing.
 */
include <constants.scad>;
use <util.scad>;
use <rubiks_cube.scad>;
use <cube_holder.scad>;
use <frame.scad>;
use <arm.scad>;
use <servo.scad>;
use <gear.scad>;
use <belt.scad>;

// This file is for previewing everything at once. All logic related
// to piece placement & arrangement belongs here; however, any logic
// related to the shape of a piece should be in its own file, one
// per printable piece in most cases.

above_cube_holder() {
  color("red", 0.8) rubiks_cube_on_point();
  color("green", 0.8) onto_point(cube_size) arm();
}

above_frame() {
  color("white", 0.8) cube_holder();

  color("grey", 0.8) front_servo_placement() servo();
  color("black", 0.8) belt() {
    front_servo_placement() servo_gear();
    holder_gear();
  }
}

color("yellow", 0.8) frame();
