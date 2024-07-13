import gleam/iterator.{map, range, to_list}
import gleam/int.{sum}

fn square(x: Int) -> Int {
  x * x
}

pub fn square_of_sum(n: Int) -> Int {
    range(from: 1, to: n)
    |> to_list
    |> sum
    |> square
}

pub fn sum_of_squares(n: Int) -> Int {
  range(from: 1, to: n)
  |> map(square)
  |> to_list
  |> sum
}

pub fn difference(n: Int) -> Int {
  square_of_sum(n) - sum_of_squares(n)
}
