import sketch

pub fn bordered_box() -> sketch.Class {
  sketch.class([sketch.outline("2px solid black")])
}

pub fn no_right_bordered_box() -> sketch.Class {
  sketch.class([
    sketch.border("2px solid black"),
    sketch.border_right_style("none"),
  ])
}
