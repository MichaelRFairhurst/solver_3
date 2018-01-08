/**
 * Copyright 2018 Mike and Nathan Fairhurst. See LICENSE for licensing.
 */
include <constants.scad>;
use <util.scad>;
use <cube_holder.scad>;
use <arm.scad>;

thickness = 4;
width = 20;
height_at_front = 70;
height_at_back = 90;
cube_to_arm_gap = 40;
cube_to_arm_len = 60;
front_servo_support_offset = cube_to_arm_len
                           - servo_block_size[0]
                           - servo_flange_length
                           + servo_screw_offsets[1]
                           + servo_screw_size/2;
front_servo_support_height = servo_gear_thickness
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
  front_servo_support();
  difference() {
    union() {
      translate([cube_to_arm_gap, 0, 0])
        ccube([thickness, width, height_at_front], y);
      translate([cube_to_arm_len, 0, 0])
        ccube([thickness, width, height_at_back], y);
    }
    above_cube_holder() onto_point(cube_size) arm($fn=100);
  }
}

module front_servo_support() {
  to_center([0, width, 0], y) {
    translate([front_servo_support_offset, 0, 0])
      cube([thickness, width / 2, front_servo_support_height]);
    translate([front_servo_support_offset, 0, front_servo_support_height - thickness])
      cube([thickness, width + servo_block_size[1], thickness]);
    translate([cube_to_arm_len, 0, front_servo_support_height - thickness])
      cube([thickness, width + servo_block_size[1], thickness]);
  }
}

module servo_placement() {
  translate([cube_size*1.5, width/2 + servo_block_size[1]/2, 0])
    rotate([0, 180, 0])
    children();
}
