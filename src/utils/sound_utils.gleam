import models/sound

pub fn display_sound_name(sound: sound.Sound) {
  case sound {
    x if x.sound == "sometch" -> "*-tch"
    x -> x.sound
  }
}
