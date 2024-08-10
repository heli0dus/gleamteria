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
import views/tact

fn track_line_holder() {
  sketch.class([
    sketch.display("grid"),
    sketch.gap(px(2)),
    sketch.grid_template_columns("repeat(4, 1fr)"),
    sketch.grid_template_rows("repeat(1, 1fr)"),
    //sketch.grid_template_areas(["A A B B B C C C", "A A D D E E F F"]),
    sketch.justify_items("begin"),
    sketch.margin(px(10)),
    sketch.margin_top(px(20)),
    sketch.margin_bottom(px(20)),
    sketch.padding(px(0)),
    sketch.width(px(800)),
    sketch.height(px(100)),
    sketch.box_sizing("border-box"),
    sketch.border_collapse("collapse"),
  ])
}

pub fn multiline_track_view(model: data_core.Model, track: Int) {
  let assert Ok(current_track) = model.tracks |> list_utils.at(track)
  let tacts = current_track.tacts

  html.div(
    sketch.class([sketch.display("flex")]),
    [],
    tacts
      |> list_utils.split_by(4)
      |> list.map(fn(line) {
        line |> list.index_map(fn(tact, idx) { tact.view(model, track, idx) })
      })
      |> list.map(fn(line) { html.div(track_line_holder(), [], line) }),
  )
}
