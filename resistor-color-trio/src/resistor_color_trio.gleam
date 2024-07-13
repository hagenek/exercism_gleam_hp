import gleam/int
import gleam/list
import gleam/result
import gleam/string

pub type Resistance {
  Resistance(unit: String, value: Int)
}

fn color_to_num(color: String) {
  case color {
    "black" -> 0
    "brown" -> 1
    "red" -> 2
    "orange" -> 3
    "yellow" -> 4
    "green" -> 5
    "blue" -> 6
    "violet" -> 7
    "grey" -> 8
    "white" -> 9
  }
}

pub fn label(colors: List(String)) -> Result(Resistance, Nil) {
  case colors |> list.map(color_to_num) {
    [first, second, zeroes] ->
      first <> second <> string.repeat("0", result.unwrap(int.parse(zeroes), 0))
    _ -> "bad input"
  }
}
