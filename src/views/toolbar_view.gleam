import data_core
import gleam/list
import gleam/option.{Some}
import gleam_community/colour
import lustre/event
import models/sound
import sketch
import sketch/lustre/element/html
import sketch/size.{px}
import styles
import utils/color_utils
import utils/img_utils
import utils/list_utils

fn toolbar_style() {
  sketch.class([
    sketch.compose(styles.bordered_box()),
    sketch.width(px(900)),
    sketch.height(px(70)),
    sketch.border_radius(px(3)),
    sketch.padding(px(10)),
  ])
}

fn left_rounded_border() {
  sketch.class([
    sketch.compose(styles.no_right_bordered_box()),
    sketch.border_top_left_radius(px(3)),
    sketch.border_bottom_left_radius(px(3)),
  ])
}

fn right_rounded_border() {
  sketch.class([
    sketch.border_style("solid"),
    sketch.compose(styles.no_right_bordered_box()),
    sketch.border_top_right_radius(px(3)),
    sketch.border_bottom_right_radius(px(3)),
  ])
}

fn sound_button_outline_color(model: data_core.Model, sound: sound.Sound) {
  case model.toolbar.current {
    Some(snd) if snd == sound -> [
      // sketch.border_width(px(2)),
      // sketch.border_bottom_width(px(4)),
      // sketch.border_top_width(px(4)),
      // sketch.border_color(
      //   model.visuals.palette.selected_sound_border
      //   |> color_utils.extract_to_css,
      // ),
      sketch.border_color(
        model.visuals.palette.selected_sound_border
        |> color_utils.extract_to_css,
      ),
      //sketch.outline_width("2px"),
    ]
    _ ->
      case
        list.take_while(model.toolbar.sounds, fn(x) { x != sound })
        |> list.reverse
      {
        [x, ..] ->
          case sound_equals_current(model, x) {
            True -> [
              sketch.border_left_color(
                model.visuals.palette.selected_sound_border
                |> color_utils.extract_to_css,
              ),
            ]
            False -> []
          }
        _ -> []
      }
  }
}

fn sound_equals_current(model: data_core.Model, sound: sound.Sound) -> Bool {
  model.toolbar.current
  |> option.map(fn(snd) { snd == sound })
  |> option.unwrap(False)
}

fn rounded_sound_buttons(model: data_core.Model, sounds: List(sound.Sound)) {
  case sounds {
    [x] -> [
      html.div(
        sketch.class(
          [
            [sketch.border_radius(px(3)), sketch.height(px(50))],
            sound_button_outline_color(model, x),
          ]
          |> list.concat,
        ),
        [],
        img_utils.img_for_sound(model, x),
      ),
    ]
    [x, ..xs] -> [
      html.div(
        sketch.class(
          [
            [sketch.compose(left_rounded_border()), sketch.height(px(50))],
            sound_button_outline_color(model, x),
          ]
          |> list.concat,
        ),
        [],
        img_utils.img_for_sound(model, x),
      ),
      ..last_rounded_sound_buttons(model, xs)
    ]
    [] -> []
  }
}

fn last_rounded_sound_buttons(model: data_core.Model, sounds: List(sound.Sound)) {
  case sounds {
    [x] -> [
      html.div(
        sketch.class(
          [
            [sketch.compose(right_rounded_border()), sketch.height(px(50))],
            sound_button_outline_color(model, x),
          ]
          |> list.concat,
        ),
        [],
        img_utils.img_for_sound(model, x),
      ),
    ]
    [x, ..xs] -> [
      html.div(
        sketch.class(
          [
            [
              sketch.compose(styles.no_right_bordered_box()),
              sketch.height(px(50)),
            ],
            sound_button_outline_color(model, x),
          ]
          |> list.concat,
        ),
        [],
        img_utils.img_for_sound(model, x),
      ),
      ..last_rounded_sound_buttons(model, xs)
    ]
    [] -> []
  }
}

fn sound_buttons(model: data_core.Model, sounds: List(sound.Sound)) {
  sounds
  |> list.map(fn(x) {
    html.div(
      sketch.class(
        [
          [
            sketch.compose(styles.no_right_bordered_box()),
            sketch.height(px(50)),
          ],
          sound_button_outline_color(model, x),
        ]
        |> list.concat,
      ),
      [],
      img_utils.img_for_sound(model, x),
    )
  })
}

pub fn view(model: data_core.Model) {
  html.div(toolbar_style(), [], [
    html.div(
      sketch.class([
        sketch.display("grid"),
        sketch.grid_template_columns("repeat(4, 1fr)"),
        //sketch.column_gap(px(2)),
        sketch.box_sizing("border-box"),
        sketch.border_collapse("collapse"),
        sketch.first_child([
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
      ]),
      [],
      sound_buttons(model, model.toolbar.sounds),
    ),
  ])
}
