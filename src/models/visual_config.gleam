import catppuccin
import gleam/dict
import gleam/option.{type Option, None, Some}
import gleam_community/colour.{type Color}

pub type VisualConfig {
  VisualConfig(assets: Assets, palette: ColorPalette)
}

pub fn default_visual_config() {
  VisualConfig(default_assets(), default_palette())
}

//---------Assets----------

pub type Assets {
  Assets(paths: dict.Dict(String, String))
}

pub fn default_assets() {
  Assets(
    dict.from_list([
      #("ton", "./assets/default/ton.svg"),
      #("tin", "./assets/default/tin.svg"),
      #("tch", "./assets/default/tch.svg"),
      #("sometch", "./assets/default/sometch.svg"),
    ]),
  )
}

//---------Palette----------

pub type ColorPalette {
  ColorPalette(
    background: Option(Color),
    beat: Option(Color),
    off_beat: Option(Color),
    triole: Option(Color),
    quadras: Option(Color),
    selected_sound_border: Option(Color),
    cell_hover: Option(Color),
  )
}

pub fn default_palette() {
  ColorPalette(
    Some(catppuccin.latte() |> catppuccin.base |> catppuccin.to_color),
    Some(catppuccin.latte() |> catppuccin.red |> catppuccin.to_color),
    Some(catppuccin.latte() |> catppuccin.sapphire |> catppuccin.to_color),
    Some(catppuccin.latte() |> catppuccin.mantle |> catppuccin.to_color),
    Some(catppuccin.latte() |> catppuccin.mantle |> catppuccin.to_color),
    Some(colour.red),
    None,
  )
}
