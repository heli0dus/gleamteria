import models/sound.{type Sound, no_sound}

pub type Tact {
  Tact(
    beat: Sound,
    second_of_4: Sound,
    second_of_3: Sound,
    off_beat: Sound,
    third_of_3: Sound,
    fourh_of_4: Sound,
  )
}

pub const empty_tact = Tact(
  beat: no_sound,
  second_of_4: no_sound,
  second_of_3: no_sound,
  off_beat: no_sound,
  third_of_3: no_sound,
  fourh_of_4: no_sound,
)
