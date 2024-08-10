import data_core
import gleam/dict
import gleam/result
import lustre/attribute
import models/sound
import sketch
import sketch/lustre/element/html
import sketch/size.{percent}

pub fn img_for_sound(model: data_core.Model, sound: sound.Sound) {
  model.visuals.assets.paths
  |> dict.get(sound.sound)
  |> result.map(fn(src) {
    [
      html.img(
        sketch.class([
          sketch.max_height(percent(100)),
          sketch.max_width(percent(100)),
        ]),
        [attribute.src(src)],
      ),
    ]
  })
  |> result.unwrap([])
}
