/**
 * Copyright 2018 Mike and Nathan Fairhurst. See LICENSE for licensing.
 */
include <constants.scad>;
use <util.scad>;

// Begin how to print this piece (orientation, etc)

// Begin modules that can be used to assemble this piece in solver_3.scad

// Get the size of a gear (circumference) without the teeth,
// based on teeth size and num teeth
function gear_inner_circumference(teeth_size, num_teeth)
  = teeth_size * num_teeth;

// Get the size of a gear (radius) without the teeth, based on
// teeth size and num teeth
function gear_inner_radius(teeth_size, num_teeth)
  = gear_inner_circumference(teeth_size, num_teeth) / 3.14159 / 2;

// Get the size of a gear (radius) including the teeth, based on
// teeth size and num teeth
function gear_outer_radius(teeth_size, num_teeth)
  = gear_inner_radius(teeth_size, num_teeth)
    + gear_tooth_additional_radius(teeth_size);

// Get the size of a gear tooth such that it is on a gear with num_teeth
// and fits inside (teeth included) outer_radius.
function gear_size_for_outer_radius_and_teeth_count(outer_radius, num_teeth)
  = let(basic_teeth_size = other_radius*2 / num_teeth)
    basic_teeth_size
    * ((outer_radius - gear_tooth_additional_radius(basic_teeth_size))
       / outer_radius);

// Get the additional radius on a gear by its tooth size. Since
// these are right triangles, we simply cut one side in half to get
// a right angle and use pythag.
function gear_tooth_additional_radius(tooth_size)
  = sqrt(sqr(tooth_size) - sqr(tooth_size/2));

// Create a gear based on number and size of teeth
module gear(teeth_size, num_teeth, thickness) {
  radius = gear_inner_radius(teeth_size, num_teeth);
  linear_extrude(thickness) {
    circle(radius, $fn=num_teeth);
    for (i=[1:num_teeth]) {
      rotate([0, 0, 360/num_teeth*i]) translate([radius, 0]) circle(teeth_size, $fn=3);
    }
  }
}

// A gear which must fit some number of teeth within some outer radius,
// accepts a number of teeth and a thickness as well.
module fixed_outer_size_gear(outer_radius, num_teeth, thickness) {
  basic_teeth_size = outer_radius*2 / num_teeth;
  inner_gear_size = outer_radius - gear_tooth_additional_radius(basic_teeth_size);
  adjustment_ratio = inner_gear_size / outer_radius;
  gear(basic_teeth_size * adjustment_ratio, num_teeth, thickness);
}
