// TODO: import the `gleam/int` module
// TODO: import the `gleam/float` module
// TODO: import the `gleam/string` module

import gleam/int
import gleam/float
import gleam/string

pub fn pence_to_pounds(pence) {
  let a = int.to_float(pence)
  let b = a /. 100.0
  b
}

pub fn pounds_to_string(pounds) {
  "£" <> float.to_string(pounds)
}
