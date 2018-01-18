/**
 * Copyright 2018 Mike and Nathan Fairhurst. See LICENSE for licensing.
 */

include <constants.scad>

// Begin config specific to this piece.
_lever_length = 35;

// Begin how to print this piece (orientation, etc)
torque_tester(_lever_length, $fn=30);

// module that can help measure the torque of a real cube
// specify:
//   - height/width/depth of the cube
//   - the thickness of the measurer
//   - the number of layers of the cube
//   - the lever distance from where you'll measure the torque
//
// To use the device, place it on a layer, and tie a weight to a weight point
// that is perpendicular to the floor.  If the cube rotates, it must take less than
// weight/lever_length to move the cube.
module torque_tester(lever_length, cube_size=cube_size, layer_count=3, wall_thickness=2) {
  depth = cube_size / (layer_count * 1.33);
  tolerant_cube_size = cube_size + $tol;
  width = tolerant_cube_size + wall_thickness * 2;
  difference() {
    cube([width, depth, width], center=true);
    cube([tolerant_cube_size, 3*depth, tolerant_cube_size], center=true);
  }
  for (i=[0:3])
    rotate(i*90, y)
    translate([-width/2, 0, 0])
    wing(depth, lever_length - width/2, wall_thickness * 1.25);
}

module wing(width, length, wall_thickness=2) {
  translate([-length - wall_thickness/2, 0, 0]) {
    difference() {
      translate([0, -width/2, -wall_thickness/2])
        cube([length + wall_thickness/2, width, wall_thickness]);
      cylinder(h=wall_thickness*3, r=wall_thickness*2, center=true);
    };

    for (i=[0:3])
      rotate([90, 0, 0])
      translate([0, 0, (1-i)*wall_thickness])
      cylinder(
        h=wall_thickness,
        r1=wall_thickness/(i % 2 + 1),
        r2=wall_thickness/((i + 1) % 2 + 1));
  }
}
