import gleam/float
import gleam/result

fn calc_distance(x: Float, y: Float) -> Float {
  float.square_root({x *. x} +. { y *. y}) |> result.unwrap(11.0)
}

pub fn score(x: Float, y: Float) -> Int {
  case calc_distance(x, y) {
    d if d >. 10.0 -> 0
    d if d >. 5.0 -> 1
    d if d >. 1.0 -> 5
    d if d >=. 0.0 -> 10
    _ -> 0
  }
}
