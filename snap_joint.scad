include <constants.scad>
use <util.scad>

module cantilever(length, width, thickness, overhang) {
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
    for (i=[0:1])
      translate([0, (i*2 - 0.5)*thickness, 0])
      difference() {
        translate([0, -i*thickness/2, 0])
          square(thickness/2);
        translate([thickness/2, 0, 0])
          circle(thickness/2, $fn=30);
      }
  }
}

module cantilever_negative(length, width, thickness, overhang) {
  inner_length = length - overhang;
  clearance = sqrt(sqr(overhang + thickness) + sqr(overhang));
  linear_extrude(width) {
    polygon([
      [0, -$tol],
      [inner_length - $tol, -$tol],
      [inner_length - $tol, -overhang - $tol],
      [inner_length + $tol*sqrt(2)/2, -overhang - $tol],
      [length + $tol, -$tol*sqrt(2)/2],
      [length + $tol, clearance + $tol],
      [-$tol, clearance + $tol],
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

_width = 4;
_thickness = 2;
_length = 12;
_overhang = 2;

cantilever(_length, _width, _thickness, _overhang);
color("blue", 0.8)
  cantilever_negative(_length, _width / 2, _thickness, _overhang);
