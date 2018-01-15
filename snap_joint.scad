use <util.scad>

module cantilever(width, thickness, snap_length, overhang) {
  inner_length = snap_length - overhang;
  linear_extrude(width) {
    polygon([
      [0,0],
      [inner_length,0],
      [inner_length,-overhang],
      [snap_length, 0],
      [snap_length, thickness],
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

module cantilever_negative(width, thickness, snap_length, overhang, tolerance) {
  inner_length = snap_length - overhang;
  flex_space = sqrt(sqr(overhang+thickness)+sqr(overhang));
  linear_extrude(width) {
    polygon([
      [0,-tolerance],
      [inner_length-tolerance,-tolerance],
      [inner_length-tolerance,-overhang-tolerance],
      [inner_length+tolerance*sqrt(2)/2,-overhang-tolerance],
      [snap_length+tolerance, -tolerance*sqrt(2)/2],
      [snap_length+tolerance, flex_space + tolerance],
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
_snap_length = 12;
_overhang = 2;
_tolerance = 0.32;

cantilever(_width, _thickness, _snap_length, _overhang);
color("blue", 0.8)
  cantilever_negative(_width / 2, _thickness, _snap_length, _overhang, _tolerance);
*/
