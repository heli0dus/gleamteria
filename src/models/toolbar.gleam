import gleam/option.{type Option}
import gleam/set
import models/sound.{type Sound}

pub type Model {
  ToolbarModel(sounds: List(Sound), current: Option(Sound), bpm: Int)
}

pub fn default_toolbar_model() {
  ToolbarModel(set.to_list(sound.berimbau_sounds()), option.None, 90)
}
