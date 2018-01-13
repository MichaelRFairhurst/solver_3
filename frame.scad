/**
 * Copyright 2018 Mike and Nathan Fairhurst. See LICENSE for licensing.
 */
include <constants.scad>;
use <util.scad>;
use <cube_holder.scad>;
use <arm.scad>;
use <belt.scad>;

thickness = 4;
width = 20;
height_at_front = 120;
height_at_back = 140;
cube_to_arm_gap = 60;
cube_to_arm_len = 80;

cube_spinner_belt_size = 120;

cube_spinner_servo_belt_distance = belt_distance(
                                cube_spinner_belt_size,
                                servo_gear_thickness,
                                servo_gear_thickness * 2);

cube_spinner_servo_offset = sqrt(sqr(cube_spinner_servo_belt_distance), sqr(width + servo_block_size[1]/2));

cube_spinner_servo_support_offset = servo_block_size[0]/2 + servo_screw_offsets[1]/2;
cube_spinner_servo_support_height = servo_gear_thickness
                           + servo_flange_offset
                           + thickness
                           - servo_flange_thickness;

// Begin how to print this piece (orientation, etc)
rotate([90, 0, 0]) frame();

// Begin modules that can be used to assemble this piece in solver_3.scad

module above_frame() {
  up(thickness) children();
}

module frame() {
  translate([-width/2, 0, 0])
    ccube([cube_to_arm_len + width/2, width, thickness], y);
  translate([cube_spinner_servo_offset - cube_spinner_servo_support_offset, 0, 0])
    cube_spinner_servo_support();
  translate([cube_spinner_servo_offset + cube_spinner_servo_support_offset, 0, 0])
    cube_spinner_servo_support();
  difference() {
    union() {
      translate([cube_to_arm_gap, 0, 0])
        ccube([thickness, width, height_at_front], y);
      translate([cube_to_arm_len, 0, 0])
        ccube([thickness, width, height_at_back], y);
    }
    above_cube_holder() onto_point(cube_size) arm(include_gears=false, $fn=100);
  }
}

module cube_spinner_servo_support() {
  to_center([0, width, 0], y) {
      ccube([thickness, width / 2, cube_spinner_servo_support_height], x);
    translate([0, 0, cube_spinner_servo_support_height - thickness])
      ccube([thickness, width + servo_block_size[1], thickness], x);
  }
}

module cube_spinner_servo_placement() {
  translate([cube_spinner_servo_offset, width/2 + servo_block_size[1]/2, 0])
    rotate([0, 180, 0])
    children();
}
