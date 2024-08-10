import gleam/list

pub fn at(xs: List(a), idx: Int) -> Result(a, IndexOutOfBounds) {
  case xs {
    [] -> Error(IndexOutOfBounds)
    [x, ..] if idx == 0 -> Ok(x)
    [_, ..xs_] if idx > 0 -> at(xs_, idx - 1)
    [_, ..] -> Error(IndexOutOfBounds)
  }
}

pub type IndexOutOfBounds {
  IndexOutOfBounds
}

pub fn split_by(xs: List(a), cnt: Int) -> List(List(a)) {
  case xs {
    [_, ..] -> {
      let #(line, next) = list.split(xs, cnt)
      [line, ..split_by(next, cnt)]
    }
    [] -> []
  }
}
