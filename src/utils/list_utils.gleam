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

pub fn put_at(
  xs: List(a),
  idx: Int,
  elem: a,
) -> Result(List(a), IndexOutOfBounds) {
  case xs |> list.length < idx {
    True -> Error(IndexOutOfBounds)
    False -> {
      let head = list.take(xs, idx)
      let tail = list.drop(xs, idx + 1)
      [head, [elem], tail] |> list.concat |> Ok
    }
  }
}

pub fn zip_with_index(xs: List(a)) -> List(#(a, Int)) {
  case list.length(xs) {
    n if n <= 0 -> []
    n -> xs |> list.zip(list.range(0, n - 1))
  }
}
