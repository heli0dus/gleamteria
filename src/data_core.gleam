import models/sound
import models/toolbar
import models/track.{type Track}
import models/visual_config.{type VisualConfig}

pub type Model {
  Model(visuals: VisualConfig, toolbar: toolbar.Model, tracks: List(Track))
}

pub type Msg =
  BetaMsg

pub type BetaMsg {
  AddSound(track: Int, tact: Int, sound: Int)
  SetActiveSound(sound: sound.Sound)
  AddLine
  RemoveLine
}
