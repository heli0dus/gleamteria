import catppuccin
import data_core
import gleam/list
import gleam/option.{Some}
import gleam_community/colour
import lustre/event
import models/sound
import sketch
import sketch/lustre/element/html
import sketch/size.{percent, px}
import styles
import utils/color_utils
import utils/img_utils
import utils/list_utils
import utils/sound_utils

fn toolbar_style(model: data_core.Model) {
  sketch.class([
    sketch.outline("2px solid"),
    sketch.outline_color(
      model.visuals.palette.text_and_border |> color_utils.extract_to_css,
    ),
    //sketch.compose(styles.bordered_box()),
    sketch.width(px(900)),
    sketch.height(px(70)),
    sketch.border_radius(px(3)),
    sketch.padding(px(10)),
    sketch.display("flex"),
    sketch.align_items("center"),
    sketch.background_color(
      model.visuals.palette.secondary_background |> color_utils.extract_to_css,
    ),
  ])
}

fn rounded_button_block_style(model: data_core.Model) {
  sketch.class([
    sketch.compose(styles.no_right_bordered_box(model)),
    sketch.max_height(px(50)),
    sketch.max_width(px(100)),
    sketch.border_color(
      model.visuals.palette.text_and_border |> color_utils.extract_to_css,
    ),
    sketch.background_color(
      model.visuals.palette.surface
      |> color_utils.extract_to_css,
    ),
    //sketch.max_width(percent(10)),
    //sketch.display("grid"),
    //sketch.grid_template_columns("repeat(2, 1fr)"),
    sketch.first_child([
      //sketch.compose(styles.no_right_bordered_box()),
      //sketch.border_left("2px solid"),
      // sketch.border_left_width(px(2)),
      sketch.border_top_left_radius(px(3)),
      sketch.border_bottom_left_radius(px(3)),
    ]),
    sketch.last_child([
      sketch.border_right_style("solid"),
      sketch.border_right_width(px(2)),
      sketch.border_top_right_radius(px(3)),
      sketch.border_bottom_right_radius(px(3)),
    ]),
  ])
}

// fn sound_button_outline_color(model: data_core.Model, sound: sound.Sound) {
//   case model.toolbar.current {
//     Some(snd) if snd == sound -> [
//       sketch.outline_style("solid"),
//       sketch.outline_width("2px"),
//       sketch.outline_offset("-2px"),
//       sketch.outline_color(
//         model.visuals.palette.selected_sound_border
//         |> color_utils.extract_to_css,
//       ),
//     ]
//     _ ->
//       case
//         list.take_while(model.toolbar.sounds, fn(x) { x != sound })
//         |> list.reverse
//       {
//         [x, ..] ->
//           case sound_equals_current(model, x) {
//             True -> [
//               // sketch.border_left_color(
//               //   model.visuals.palette.selected_sound_border
//               //   |> color_utils.extract_to_css,
//               // ),
//               sketch.border_left_style("none"),
//             ]
//             False -> []
//           }
//         _ -> []
//       }
//   }
// }

fn sound_button_outline_color(model: data_core.Model, sound: sound.Sound) {
  case model.toolbar.current {
    Some(snd) if snd == sound -> [
      sketch.outline_color(
        model.visuals.palette.selected_sound_border
        |> color_utils.extract_to_css,
      ),
      sketch.z_index(10),
    ]
    _ -> [
      sketch.outline_color(
        model.visuals.palette.text_and_border
        |> color_utils.extract_to_css,
      ),
    ]
  }
}

fn sound_equals_current(model: data_core.Model, sound: sound.Sound) -> Bool {
  model.toolbar.current
  |> option.map(fn(snd) { snd == sound })
  |> option.unwrap(False)
}

fn sound_buttons(model: data_core.Model, sounds: List(sound.Sound)) {
  sounds
  |> list.map(fn(x) {
    html.div(
      sketch.class(
        [
          [
            //sketch.compose(styles.no_right_bordered_box(model)),
            sketch.outline_style("solid"),
            sketch.outline_width("2px"),
            sketch.max_height(px(50)),
            sketch.max_width(px(100)),
            sketch.background_color(
              model.visuals.palette.surface
              |> color_utils.extract_to_css,
            ),
            //sketch.max_width(percent(10)),
            sketch.display("grid"),
            sketch.grid_template_columns("repeat(2, 1fr)"),
            sketch.first_child([
              sketch.border_top_left_radius(px(3)),
              sketch.border_bottom_left_radius(px(3)),
            ]),
            sketch.last_child([
              sketch.border_top_right_radius(px(3)),
              sketch.border_bottom_right_radius(px(3)),
            ]),
          ],
          sound_button_outline_color(model, x),
        ]
        |> list.concat,
      ),
      [event.on_click(data_core.SetActiveSound(x))],
      [
        img_utils.img_for_sound(model, x),
        [
          html.span(
            sketch.class([
              sketch.display("flex"),
              sketch.align_items("center"),
              sketch.justify_content("center"),
            ]),
            [],
            [html.text(x |> sound_utils.display_sound_name)],
          ),
        ],
      ]
        |> list.concat,
    )
  })
}

pub fn view(model: data_core.Model) {
  html.div(toolbar_style(model), [], [
    html.div(
      sketch.class([
        sketch.display("grid"),
        sketch.max_width(px(4 * 100)),
        sketch.grid_template_columns("repeat(4, 1fr)"),
        sketch.column_gap(px(2)),
        sketch.box_sizing("border-box"),
        sketch.border_collapse("collapse"),
      ]),
      [],
      sound_buttons(model, model.toolbar.sounds),
    ),
    html.div(
      sketch.class([
        sketch.display("grid"),
        sketch.max_width(px(200)),
        sketch.grid_template_columns("50px 100px 50px"),
        sketch.box_sizing("border-box"),
        sketch.border_collapse("collapse"),
        sketch.margin_left_("auto"),
      ]),
      [],
      [
        html.button(
          sketch.class([
            sketch.important(sketch.background_color(
              catppuccin.latte()
              |> catppuccin.maroon
              |> catppuccin.to_color
              |> colour.to_css_rgba_string,
            )),
            sketch.compose(rounded_button_block_style(model)),
          ]),
          [],
          [
            html.span(
              sketch.class([
                sketch.display("flex"),
                sketch.align_items("center"),
                sketch.justify_content("center"),
                sketch.height(percent(100)),
              ]),
              [event.on_click(data_core.RemoveLine)],
              [html.text("-")],
            ),
          ],
        ),
        html.div(
          sketch.class([
            sketch.compose(rounded_button_block_style(model)),
            sketch.height(px(46)),
            sketch.background_color(
              model.visuals.palette.surface
              |> color_utils.extract_to_css,
            ),
          ]),
          [],
          [
            html.span(
              sketch.class([
                sketch.display("flex"),
                sketch.align_items("center"),
                sketch.justify_content("center"),
                sketch.height(percent(100)),
              ]),
              [],
              [html.text("строки")],
            ),
          ],
        ),
        html.button(
          sketch.class([
            sketch.important(sketch.background_color(
              catppuccin.latte()
              |> catppuccin.green
              |> catppuccin.to_color
              |> colour.to_css_rgba_string,
            )),
            sketch.compose(rounded_button_block_style(model)),
          ]),
          [],
          [
            html.span(
              sketch.class([
                sketch.display("flex"),
                sketch.align_items("center"),
                sketch.justify_content("center"),
                sketch.height(percent(100)),
              ]),
              [event.on_click(data_core.AddLine)],
              [html.text("+")],
            ),
          ],
        ),
      ],
    ),
  ])
}
