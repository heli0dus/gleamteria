import data_core
import gleam/int
import gleam/list
import gleam/option.{None, Some}
import gleam/result
import lustre
import models/sound
import models/tact_model
import models/toolbar
import models/track
import models/visual_config
import sketch
import sketch/lustre as sketch_lustre
import sketch/lustre/element/html
import sketch/size
import utils/color_utils
import utils/list_utils
import views/tact
import views/toolbar_view
import views/track_view

// MAIN ------------------------------------------------------------------------

pub fn main() {
  // Initialise the cache. Two strategies can be used in browser, only one
  // on server-side.
  let assert Ok(cache) = sketch.cache(strategy: sketch.Ephemeral)
  // Select the output of the generated stylesheet.
  sketch_lustre.node()
  // Add the sketch CSS generation "view middleware".
  |> sketch_lustre.compose(view, cache)
  // Give the new view function to lustre runtime!
  |> lustre.simple(init, update, _)
  // And voilà!
  |> lustre.start("#app", Nil)
}

// MODEL -----------------------------------------------------------------------

type Model =
  data_core.Model

fn init(_: Nil) -> Model {
  data_core.Model(
    visual_config.default_visual_config(),
    toolbar.default_toolbar_model(),
    [track.empty_track("berimbau")],
  )
}

// UPDATE ----------------------------------------------------------------------

pub type Msg =
  data_core.Msg

fn update(model: Model, msg: Msg) -> Model {
  case msg {
    data_core.AddSound(track, tact, sound) -> {
      let assert Ok(current_track) = model.tracks |> list_utils.at(track)
      let assert Ok(current_tact) = current_track.tacts |> list_utils.at(tact)

      let new_tact = case sound {
        0 ->
          case current_tact.beat {
            x if Some(x) == model.toolbar.current ->
              tact_model.Tact(..current_tact, beat: sound.no_sound)
            _ ->
              case
                { model.toolbar.current |> option.unwrap(sound.no_sound) }.instrument
                == current_track.instrument
                || model.toolbar.current |> option.is_none
              {
                True -> {
                  let current_sound =
                    model.toolbar.current |> option.unwrap(sound.no_sound)
                  tact_model.Tact(..current_tact, beat: current_sound)
                }
                False -> current_tact
              }
          }
        1 ->
          case current_tact.second_of_4 {
            x if Some(x) == model.toolbar.current ->
              tact_model.Tact(..current_tact, second_of_4: sound.no_sound)
            _ ->
              case
                { model.toolbar.current |> option.unwrap(sound.no_sound) }.instrument
                == current_track.instrument
                || model.toolbar.current |> option.is_none
              {
                True -> {
                  let current_sound =
                    model.toolbar.current |> option.unwrap(sound.no_sound)
                  tact_model.Tact(..current_tact, second_of_4: current_sound)
                }
                False -> current_tact
              }
          }
        2 ->
          case current_tact.second_of_3 {
            x if Some(x) == model.toolbar.current ->
              tact_model.Tact(..current_tact, second_of_3: sound.no_sound)
            _ ->
              case
                { model.toolbar.current |> option.unwrap(sound.no_sound) }.instrument
                == current_track.instrument
                || model.toolbar.current |> option.is_none
              {
                True -> {
                  let current_sound =
                    model.toolbar.current |> option.unwrap(sound.no_sound)
                  tact_model.Tact(..current_tact, second_of_3: current_sound)
                }
                False -> current_tact
              }
          }
        3 ->
          case current_tact.off_beat {
            x if Some(x) == model.toolbar.current ->
              tact_model.Tact(..current_tact, off_beat: sound.no_sound)
            _ ->
              case
                { model.toolbar.current |> option.unwrap(sound.no_sound) }.instrument
                == current_track.instrument
                || model.toolbar.current |> option.is_none
              {
                True -> {
                  let current_sound =
                    model.toolbar.current |> option.unwrap(sound.no_sound)
                  tact_model.Tact(..current_tact, off_beat: current_sound)
                }
                False -> current_tact
              }
          }
        4 ->
          case current_tact.third_of_3 {
            x if Some(x) == model.toolbar.current ->
              tact_model.Tact(..current_tact, third_of_3: sound.no_sound)
            _ ->
              case
                { model.toolbar.current |> option.unwrap(sound.no_sound) }.instrument
                == current_track.instrument
                || model.toolbar.current |> option.is_none
              {
                True -> {
                  let current_sound =
                    model.toolbar.current |> option.unwrap(sound.no_sound)
                  tact_model.Tact(..current_tact, third_of_3: current_sound)
                }
                False -> current_tact
              }
          }
        5 ->
          case current_tact.fourh_of_4 {
            x if Some(x) == model.toolbar.current ->
              tact_model.Tact(..current_tact, fourh_of_4: sound.no_sound)
            _ ->
              case
                { model.toolbar.current |> option.unwrap(sound.no_sound) }.instrument
                == current_track.instrument
                || model.toolbar.current |> option.is_none
              {
                True -> {
                  let current_sound =
                    model.toolbar.current |> option.unwrap(sound.no_sound)
                  tact_model.Tact(..current_tact, fourh_of_4: current_sound)
                }
                False -> current_tact
              }
          }
        _ -> panic as "Tacts only have 6 sounds"
      }

      let new_track =
        track.Track(
          ..current_track,
          tacts: current_track.tacts
            |> list_utils.put_at(tact, new_tact)
            |> result.unwrap([]),
        )
      let new_tracks =
        model.tracks |> list_utils.put_at(track, new_track) |> result.unwrap([])
      data_core.Model(..model, tracks: new_tracks)
    }
    data_core.AddLine -> {
      let current_track =
        model.tracks
        |> list_utils.at(0)
        |> result.unwrap(track.empty_track("berimbau"))
      let new_track =
        track.Track(
          "berimbau",
          [current_track.tacts, list.repeat(tact_model.empty_tact, 4)]
            |> list.concat,
        )
      data_core.Model(
        ..model,
        tracks: [new_track, ..model.tracks |> list.drop(1)],
      )
    }
    data_core.RemoveLine -> {
      let current_track =
        model.tracks
        |> list_utils.at(0)
        |> result.unwrap(track.empty_track("berimbau"))
      let new_track = case current_track.tacts |> list.length <= 4 {
        True -> current_track
        False ->
          track.Track(
            ..current_track,
            tacts: current_track.tacts
              |> list.take(list.length(current_track.tacts) - 4),
          )
      }
      data_core.Model(
        ..model,
        tracks: [new_track, ..model.tracks |> list.drop(1)],
      )
    }
    data_core.SetActiveSound(sound) -> {
      let new_current = case Some(sound) == model.toolbar.current {
        True -> None
        False -> Some(sound)
      }
      data_core.Model(
        ..model,
        toolbar: toolbar.ToolbarModel(..model.toolbar, current: new_current),
      )
    }
  }
}

// VIEW ------------------------------------------------------------------------

fn view(model: Model) {
  html.div(
    sketch.class([
      sketch.display("flex"),
      sketch.flex_wrap("wrap"),
      sketch.width(size.px(1000)),
      sketch.justify_content("center"),
      sketch.background_color(
        model.visuals.palette.background |> color_utils.extract_to_css,
      ),
    ]),
    [],
    [
      toolbar_view.view(model),
      html.div(
        sketch.class([
          sketch.width(size.px(900)),
          sketch.display("flex"),
          sketch.justify_content("center"),
          sketch.margin_top(size.px(5)),
          sketch.outline("2px solid"),
          sketch.outline_color(
            model.visuals.palette.text_and_border |> color_utils.extract_to_css,
          ),
          sketch.border_radius(size.px(3)),
        ]),
        [],
        [track_view.multiline_track_view(model, 0)],
      ),
    ],
  )
  // tact.view(model, 0, 0)
}
