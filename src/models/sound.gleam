import gleam/set.{type Set}

pub type Sound {
  Sound(instrument: String, sound: String)
}

pub const tch = Sound("berimbau", "tch")

pub const tin = Sound("berimbau", "tin")

pub const ton = Sound("berimbau", "ton")

pub const some_tch = Sound("berimbau", "sometch")

pub const no_sound = Sound("", "")

pub fn berimbau_sounds() -> Set(Sound) {
  set.from_list([tch, tin, ton, some_tch])
}
