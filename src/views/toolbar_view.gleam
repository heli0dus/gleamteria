import data_core
import gleam/list
import lustre/event
import sketch
import sketch/lustre/element/html
import sketch/size.{px}
import styles
import utils/color_utils
import utils/img_utils
import utils/list_utils

fn toolbar_style() {
  sketch.class([sketch.width(px(900))])
}

pub fn view(model: data_core.Model) {
  html.div(toolbar_style(), [], [])
  todo
}
