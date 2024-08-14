import data_core
import lustre/event
import sketch
import sketch/lustre/element/html
import sketch/size.{px}
import styles
import utils/color_utils
import utils/img_utils
import utils/list_utils

fn tact_grid_style() {
  sketch.class([
    sketch.display("grid"),
    sketch.gap(px(2)),
    sketch.grid_template_columns("repeat(8, 1fr)"),
    sketch.grid_template_rows("repeat(2, 1fr)"),
    sketch.grid_template_areas(["A A B B B C C C", "A A D D E E F F"]),
    sketch.justify_items("stretch"),
    sketch.margin(px(0)),
    sketch.padding(px(0)),
    sketch.width(px(200)),
    sketch.height(px(100)),
    sketch.box_sizing("border-box"),
    sketch.border_collapse("collapse"),
  ])
}

fn tact_cell_style(model: data_core.Model) {
  sketch.class([
    sketch.outline("2px solid"),
    sketch.outline_color(
      model.visuals.palette.text_and_border |> color_utils.extract_to_css,
    ),
    sketch.display("flex"),
    sketch.align_items("end"),
    sketch.justify_content("center"),
    sketch.padding(px(2)),
  ])
}

pub fn view(model: data_core.Model, track: Int, tact: Int) {
  let assert Ok(current_track) = model.tracks |> list_utils.at(track)
  let assert Ok(current_tact) = current_track.tacts |> list_utils.at(tact)
  html.div(tact_grid_style(), [], [
    html.div(
      sketch.class([
        sketch.compose(tact_cell_style(model)),
        sketch.grid_area("A"),
        sketch.background_color(
          model.visuals.palette.beat
          |> color_utils.extract_to_css,
        ),
      ]),
      [event.on_click(data_core.AddSound(track, tact, 0))],
      img_utils.img_for_sound(model, current_tact.beat),
    ),
    html.div(
      sketch.class([
        sketch.compose(tact_cell_style(model)),
        sketch.grid_area("B"),
        sketch.background_color(
          model.visuals.palette.triole
          |> color_utils.extract_to_css,
        ),
        sketch.height(px(45)),
      ]),
      [event.on_click(data_core.AddSound(track, tact, 2))],
      img_utils.img_for_sound(model, current_tact.second_of_3),
    ),
    html.div(
      sketch.class([
        sketch.compose(tact_cell_style(model)),
        sketch.grid_area("C"),
        sketch.background_color(
          model.visuals.palette.triole
          |> color_utils.extract_to_css,
        ),
        sketch.height(px(45)),
      ]),
      [event.on_click(data_core.AddSound(track, tact, 4))],
      img_utils.img_for_sound(model, current_tact.third_of_3),
    ),
    html.div(
      sketch.class([
        sketch.compose(tact_cell_style(model)),
        sketch.grid_area("D"),
        sketch.background_color(
          model.visuals.palette.quadras
          |> color_utils.extract_to_css,
        ),
      ]),
      [event.on_click(data_core.AddSound(track, tact, 1))],
      img_utils.img_for_sound(model, current_tact.second_of_4),
    ),
    html.div(
      sketch.class([
        sketch.compose(tact_cell_style(model)),
        sketch.grid_area("E"),
        sketch.background_color(
          model.visuals.palette.off_beat
          |> color_utils.extract_to_css,
        ),
      ]),
      [event.on_click(data_core.AddSound(track, tact, 3))],
      img_utils.img_for_sound(model, current_tact.off_beat),
    ),
    html.div(
      sketch.class([
        sketch.compose(tact_cell_style(model)),
        sketch.grid_area("F"),
        sketch.background_color(
          model.visuals.palette.quadras
          |> color_utils.extract_to_css,
        ),
      ]),
      [event.on_click(data_core.AddSound(track, tact, 5))],
      img_utils.img_for_sound(model, current_tact.fourh_of_4),
    ),
  ])
}
