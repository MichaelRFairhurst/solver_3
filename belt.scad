/**
 * Copyright 2018 Mike and Nathan Fairhurst. See LICENSE for licensing.
 */
include <constants.scad>;
use <util.scad>;

// Begin how to print this piece (orientation, etc)

// Begin modules that can be used to assemble this piece in solver_3.scad

// A simple belt preview module. Simply accepts some number of gears, and
// builds a belt that connects them.
//
// Example: a 2mm thick belt connecting three gears in a square
//   belt(2) mirrored([x, y]) gear(.5, 30, 5);
//
// Doesn't yet draw the teeth, and makes some assumptions:
// - Assumes all gears are level in the z axis
// - Assumes all gears are the same thickness
// - Has the same limitations as [hull] (assumes no backtracking).
module belt(size=2) {
  difference() {
    hull() minkowski() {
      children();
      cylinder(0.00001, r=size);
    }
    down(0.1) scale([1,1,2]) hull() children();
  }
}

// This an approximation for a transcendental equation, but seems to work well
// see this post: https://math.stackexchange.com/questions/123361
function gear_center_distance(belt_length, gear_size1, gear_size2) =
  let(diff=abs(gear_size1 - gear_size2))
  let(tangent_length=
    (belt_length - PI*diff + sqrt(sqr(PI*diff - belt_length) - 16*sqr(diff))) / 4)
  sqrt(sqr(diff) + sqr(tangent_length));
