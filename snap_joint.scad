use <util.scad>

module cantilever(length, width, thickness, overhang) {
  inner_length = length - overhang;
  linear_extrude(width) {
    polygon([
      [0,0],
      [inner_length,0],
      [inner_length,-overhang],
      [length, 0],
      [length, thickness],
      [0, thickness],
    ]);
    translate([0,-thickness/2,0])
      difference() {
        translate([0,0,0])
          square(thickness/2);
        translate([thickness/2,0,0])
          circle(thickness/2, $fn=30);
      }
    translate([0,thickness*1.5,0])
      difference() {
        translate([0,-thickness/2,0])
          square(thickness/2);
        translate([thickness/2,0,0])
          circle(thickness/2, $fn=30);
      }
  }
}

module cantilever_negative(length, width, thickness, overhang, tolerance) {
  inner_length = length - overhang;
  flex_space = sqrt(sqr(overhang+thickness)+sqr(overhang));
  linear_extrude(width) {
    polygon([
      [0,-tolerance],
      [inner_length-tolerance,-tolerance],
      [inner_length-tolerance,-overhang-tolerance],
      [inner_length+tolerance*sqrt(2)/2,-overhang-tolerance],
      [length+tolerance, -tolerance*sqrt(2)/2],
      [length+tolerance, flex_space + tolerance],
      [-tolerance, flex_space + tolerance],
      [-tolerance, -(thickness+tolerance)/2],
      [0, -(thickness+tolerance)/2],
    ]);
    translate([0,-(thickness + tolerance)/2,0])
      difference() {
        translate([0,0,0])
          square((thickness + tolerance)/2);
        translate([(thickness + tolerance)/2,0,0])
          circle((thickness - tolerance)/2, $fn=30);
      }
  }
}

/*
_width = 4;
_thickness = 2;
_length = 12;
_overhang = 2;
_tolerance = 0.32;

cantilever(_length, _width, _thickness, _overhang);
color("blue", 0.8)
  cantilever_negative(_length, _width / 2, _thickness, _overhang, _tolerance);
*/
