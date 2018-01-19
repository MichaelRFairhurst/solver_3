/**
 * Copyright 2018 Mike and Nathan Fairhurst. See LICENSE for licensing.
 */
include <constants.scad>;
use <util.scad>;
use <gear.scad>;
use <cube_holder.scad>;

cube_holder_gear();

module cube_holder_gear() {
  difference() {
    gear(servo_gear_teeth_size, servo_gear_num_teeth*4, servo_gear_thickness);
    up(servo_gear_thickness) onto_point() cube_holder(hollow=false);
  }
}
