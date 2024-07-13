import gleam/string

// Introduction
// Reversing strings (reading them from right to left, rather than from left to right) is a surprisingly common task in programming.
//
// For example, in bioinformatics, reversing the sequence of DNA or RNA strings is often important for various analyses, such as finding complementary strands or identifying palindromic sequences that have biological significance.
//
// Instructions
// Your task is to reverse a given string.
//
// Some examples:
//
// Turn "stressed" into "desserts".
// Turn "strops" into "sports".
// Turn "racecar" into "racecar".

fn do_reverse(acc: List(String), list: List(String)) {
  case list {
    [] -> acc
    [first, ..rest] -> do_reverse([first, ..acc], rest)
  }
}

pub fn reverse(value: String) -> String {
  do_reverse([], string.to_graphemes(value))
  |> string.join("")
}
