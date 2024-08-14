import data_core
import sketch
import utils/color_utils

pub fn bordered_box() -> sketch.Class {
  sketch.class([sketch.outline("2px solid black")])
}

pub fn no_right_bordered_box(model: data_core.Model) -> sketch.Class {
  sketch.class([
    // sketch.border("2px solid black"),
    sketch.border_width_("2px"),
    // sketch.border_color(
    //   model.visuals.palette.text_and_border |> color_utils.extract_to_css,
    // ),
    sketch.border_color("black"),
    sketch.border_style("solid"),
    sketch.border_right_style("none"),
  ])
}

pub fn horizontal_rounded_button_block() {
  todo
}
