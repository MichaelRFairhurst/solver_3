/**
 * Copyright 2018 Mike and Nathan Fairhurst. See LICENSE for licensing.
 */
include <constants.scad>;
use <util.scad>;

pin(10,2);

// A shape that can be used for push in parts
module pin(height, radius) {
  inner_height = height * 0.9375;
  cap_height = height - inner_height;
  difference() {
    translate([radius*sqrt(2)/2, 0, 0])
      union() {
        cylinder(h=inner_height, r=radius);
        up(inner_height)
          cylinder(h=cap_height, r1=radius, r2=radius/2);
      }
    translate([-height*2, 0, 0])
      ccube(height*2, y + z);
  }
}

