import data_core
import gleam/int
import lustre
import models/sound
import models/tact_model
import models/toolbar
import models/track
import models/visual_config
import sketch
import sketch/lustre as sketch_lustre
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
    data_core.AddSound(track, tact, sound) -> model
    data_core.AddLine -> model
    data_core.RemoveLine -> model
    data_core.SetActiveSound(sound) -> model
  }
}

// VIEW ------------------------------------------------------------------------

fn view(model: Model) {
  toolbar_view.view(model)
  //track_view.multiline_track_view(model, 0)
  // tact.view(model, 0, 0)
}
