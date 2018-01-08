/**
 * Copyright 2018 Mike and Nathan Fairhurst. See LICENSE for licensing.
 */
include <constants.scad>;
use <util.scad>;
use <gear.scad>;

// Begin config specific to this piece.
// nothing

// Begin how to print this piece (orientation, etc)
// nothing: doesn't print.

// Begin modules that can be used to assemble this piece in solver_3.scad
module servo(
    block_size=servo_block_size,
    flange_length=servo_flange_length,
    flange_thickness=servo_flange_thickness,
    flange_offset=servo_flange_offset,
    screw_offsets=servo_screw_offsets,
    screw_size=servo_screw_size,
    gear_teeth_size=servo_gear_teeth_size,
    gear_num_teeth=servo_gear_num_teeth,
    gear_thickness=servo_gear_thickness
) {
  down(gear_thickness) {
    gear(gear_teeth_size, gear_num_teeth, gear_thickness);
    servo_block(block_size);
    servo_flange(
        block_size,
        flange_length,
        flange_thickness,
        flange_offset,
        screw_offsets,
        screw_size);
  }
}

module servo_flange(block_size, length, thickness, offset, screw_offsets, screw_size) {
  down(offset) difference() {
    ccube([length + block_size[0], block_size[1], thickness], x + y);
    mirrored([x, y])
      translate([block_size[0]/2 + screw_offsets[0], screw_offsets[1], 0])
      up(thickness/2) cylinder(thickness*2, d=screw_size, center=true, $fn=20);
  }
}

module servo_block(size) {
  down(size[2]) ccube(size, x + y);
}
