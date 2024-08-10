import gleam/list
import models/tact_model.{type Tact}

pub type Track {
  Track(instrument: String, tacts: List(Tact))
}

pub fn empty_track(instrument: String) {
  Track(instrument, list.repeat(tact_model.empty_tact, 4))
}
