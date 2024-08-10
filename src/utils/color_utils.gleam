import gleam/option.{type Option}
import gleam_community/colour.{type Color}

pub fn extract_to_css(color: Option(Color)) {
  color |> option.unwrap(colour.white) |> colour.to_css_rgba_string
}
