/**
 * Copyright 2018 Mike and Nathan Fairhurst. See LICENSE for licensing.
 */

function is_number(x) = abs(x)!=undef;

// Constants specific to this file
cube_point_rotation = [45, 35.264, 180];

// Modules to be used by all parts

// Create a cube balanced on a point. If you want a specialty
// cube, you can use [onto_point] and pass in the size.
module cube_on_point(cube_size) {
  onto_point(cube_size) cube(cube_size, center=true);
}

// Wrap around a cube of [size], and it will be placed on a
// point. Make sure size is accurate, or, when you can, use
// [cube_on_point].
module onto_point(cube_size) {
  translate([0, 0, pow(pow(cube_size/2, 2)*3, 1/2)])
    rotate(cube_point_rotation)
    children();
}

// A cube with rounded corners, with centering available as
// well, via [ccube].
module rounded_cube(size, rounding, center) {
  minkowski() {
    ccube(size - rounding*2, center);
    sphere(rounding, center=true, $fn=10);
  }
}

// Move children up by z. Just cleaner than creating a 3d
// vector transform.
module up(z) {
  translate([0, 0, z]) children();
}

// Move children down by z. Just cleaner than creating a 3d
// vector transform.
module down(z) {
  translate([0, 0, -z]) children();
}

// Convenience function for creating a partially centered cube.
//
// [ccube] stands for "centered cube." Rather than having only
// two options (center on all axes or none), the axes upon which
// the cube should be centered can be passed in via the
// constants [x], [y], and [z], from constants.scad. Note you
// can add & subtract these values for a clean API.
//
// Example: a cube of width 10, centered on x & y
//   ccube(10, x + y)
//
module ccube(dims, axes) {
  realdims = is_number(dims) ? [dims, dims, dims] : dims;
  translate([
    -realdims[0]/2 * axes[0], 
    -realdims[1]/2 * axes[1], 
    -realdims[2]/2 * axes[2]
  ]) cube(dims);
}
