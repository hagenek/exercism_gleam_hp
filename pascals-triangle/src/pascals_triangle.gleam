import gleam/io
import gleam/list

fn new_number(acc: List(Int), item: Int) -> List(Int) {
  let assert [prev, ..tail] = acc
  [item + prev, ..acc]
}

fn generate_row(prev_row: List(Int)) -> List(Int) {
  let row =
    list.append(prev_row, [0])
    |> list.fold([0], new_number)
    |> list.reverse
  [1, ..list.drop(row, 1)]
}

fn nth_row(n: Int) -> List(Int) {
  case n {
    1 -> [1]
    2 -> [1, 1]
    3 -> [1, 2, 1]
    _ -> {
      let prev_row = nth_row(n - 1)
      generate_row(prev_row)
    }
  }
}

fn return_and_debug(l: List(a)) -> List(a) {
  io.debug(l)
  l
}

pub fn rows(n: Int) -> List(List(Int)) {
  let range = case n {
    0 -> []
    _ -> list.range(1, n)
  }
  range
  |> return_and_debug
  |> list.map(nth_row)
}
