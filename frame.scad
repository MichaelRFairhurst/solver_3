/**
 * Copyright 2018 Mike and Nathan Fairhurst. See LICENSE for licensing.
 */
include <constants.scad>;
use <util.scad>;
use <cube_holder.scad>;
use <arm.scad>;
use <belt.scad>;

thickness = 4;
width = 30;

// TODO import this?
claw_clips_length = claw_wall_thickness*7;

arm_gap = arm_length - arm_movement;
arm_assembly_offset = arm_movement + claw_clips_length;

cube_spinner_belt_size = 120;

cube_spinner_servo_gear_center_distance = gear_center_distance(
                                cube_spinner_belt_size,
                                servo_gear_thickness,
                                servo_gear_thickness * 2);

cube_spinner_servo_offset = sqrt(sqr(cube_spinner_servo_gear_center_distance), sqr(width + servo_block_size[1]/2));

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
  // Placed [arm_assembly], that which holds the arm & the servos to move it.
  above_cube_holder()
    onto_point(cube_size)
    rotate([45,0,180])
    arm_assembly();

  // Recreate the placement of [arm_assembly] mathematically, to get the offset
  // for the support for it that attaches to the frame.
  // TODO account for [above_cube_holder]. See hack below.
  arm_assembly_support_offset = vec_onto_point(
      cube_size,
      rotation([-45, 0, 180])
          // Regarding $tol, see [arm_assembly]
          * [arm_assembly_offset + $tol, width/2, -width/2]);

  // The little amount that protrudes past the [cube_holder].
  before_holder_length = width/2;
  // The long amount that goes from the cube holder to the [arm_assembly] support.
  after_holder_length = arm_assembly_support_offset[0];

  // Flat piece that touches the ground.
  translate([-before_holder_length, 0, 0])
    ccube([after_holder_length + before_holder_length, width, thickness], y);

  // Using our calculated [arm_assembly] placement, build a support up to it.
  translate([arm_assembly_support_offset[0], 0, 0])
    ccube([thickness, width, arm_assembly_support_offset[2]], y);

  // TODO: don't require this. See [arm_assembly_support_offset]; it explains
  // that [above_cube_holder] is not accounted for, so for now we generate
  // an extra support that's raised by this amount so that this plus the
  // original support add up to a support of the proper size.
  above_cube_holder()
    translate([arm_assembly_support_offset[0], 0, thickness])
    ccube([thickness, width, arm_assembly_support_offset[2]], y);

  // Cube spinner servo supports.
  translate([cube_spinner_servo_offset - cube_spinner_servo_support_offset, 0, 0])
    cube_spinner_servo_support();
  translate([cube_spinner_servo_offset + cube_spinner_servo_support_offset, 0, 0])
    cube_spinner_servo_support();

}

// The assembly that holds the arm, has cutouts for its motion, and holds the servos
// that perform extension/rotation.
//
// TODO: split this into a separate part that attaches to the frame. Seems too big to print at once.
module arm_assembly() {
  difference() {
    // NOTE: We add [$tol] to [arm_movement_offset], because it isn't part of the
    // global constant. It in fact must be specified here in order to be overridable
    // at the module level.
    translate([arm_assembly_offset + $tol, 0, 0]) {
      // front slot for arm
      ccube([thickness, width, width], y+z);

      // back slot for arm
      translate([arm_gap, 0, 0]) ccube([thickness, width, width], y+z);

      // connection between the slots
      down(width/2) ccube([arm_gap + thickness, width, thickness], y+z);
    }

    // Cut out the arm itself, at full retraction. See earlier comments about $tol.
    translate([arm_movement + $tol, 0, 0])
      arm(include_gears=false, $fn=100);
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
