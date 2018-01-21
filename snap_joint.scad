/**
 * Copyright 2018 Mike and Nathan Fairhurst. See LICENSE for licensing.
 */

include <constants.scad>
use <util.scad>

module cantilever(length, width, thickness, overhang, positive=true) {
  if (positive) {
    inner_length = length - overhang;
    linear_extrude(width) {
      polygon([
        [0, 0],
        [inner_length, 0],
        [inner_length, -overhang],
        [length, 0],
        [length, thickness],
        [0, thickness],
      ]);
      translate([0, thickness/2])
        mirrored([y])
        translate([0, -thickness])
        difference() {
          square(thickness/2);
          translate([thickness/2, 0])
            circle(thickness/2, $fn=30);
        }
    }
  } else {
    inner_length = length - overhang;
    clearance = get_cantilever_clearance(thickness, overhang);
    down($tol/2)
      linear_extrude(width + $tol) {
        polygon([
          [0, -$tol],
          [inner_length - $tol, -$tol],
          [inner_length - $tol, -overhang - $tol],
          [inner_length + $tol*sqrt(2)/2, -overhang - $tol],
          [length + $tol, -$tol*sqrt(2)/2],
          [length + $tol, clearance],
          [-$tol, clearance],
          [-$tol, -(thickness + $tol)/2],
          [0, -(thickness + $tol)/2],
        ]);
        translate([0, -(thickness + $tol)/2, 0])
          difference() {
            translate([0,0,0])
              square((thickness + $tol)/2);
            translate([(thickness + $tol)/2, 0, 0])
              circle((thickness - $tol)/2, $fn=30);
          }
      }
  }
}

function get_cantilever_clearance(thickness, overhang) =
  sqrt(sqr(overhang + thickness) + sqr(overhang)) + $tol;

function get_cantilever_negative_depth(thickness, overhang) =
  let(clearance=get_cantilever_clearance(thickness, overhang))
    clearance + thickness + overhang + $tol;

_width = 4;
_thickness = 2;
_length = 12;
_overhang = 2;

cantilever(_length, _width, _thickness, _overhang);
color("blue", 0.8)
  cantilever(_length, _width / 2, _thickness, _overhang, positive=false);