/**
 * Copyright 2018 Mike and Nathan Fairhurst. See LICENSE for licensing.
 */

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
module torque_tester(cube_size, wall_thickness, layer_count, lever_length) {
  difference() {
    cube([cube_size + wall_thickness * 2, cube_size / (layer_count * 1.33), cube_size + wall_thickness * 2]);
    translate([wall_thickness,-cube_size/(layer_count*1.33),wall_thickness]) cube([cube_size, cube_size*3/(layer_count*1.33), cube_size]);
  }
  translate([cube_size/2 + wall_thickness,0,cube_size/2 + wall_thickness])
  union() {
    for (i=[0:3])
    rotate(i*90,[0,1,0])
    translate([cube_size/2 + wall_thickness,0,-wall_thickness/2])
      wing(cube_size/(layer_count*1.33), lever_length - cube_size/2 - wall_thickness, wall_thickness * 1.25);
  }
}

module wing(width, depth, wall_thickness) {
  union() {
    difference() {
      cube([depth+wall_thickness/2,width,wall_thickness]);
      translate([depth, width/2, -wall_thickness])
        cylinder(wall_thickness*3, wall_thickness*2, wall_thickness*2, $fn=30);
    };

    for (i=[0:3])
      translate([depth, width/2, wall_thickness/2])
      rotate([90, 0, 0])
      translate([0, 0, (1-i)*wall_thickness])
      cylinder(
        wall_thickness,
        wall_thickness/(i % 2 + 1),
        wall_thickness/((i + 1) % 2 + 1), $fn=30);
  }
}

_cube_size = 55;
_wall_thickness = 2;
_layer_count = 3;
_lever_length = 35;

color("blue", 0.8) torque_tester(_cube_size, _wall_thickness, _layer_count, _lever_length);
