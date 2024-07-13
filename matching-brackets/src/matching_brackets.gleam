import gleam/string
import gleam/list
import gleam/dict
import gleam/bool

fn is_yin(grapheme: String, x: String) {
  let opposite = [#("[", "]"), #("{", "}"), #("(", ")")] |> dict.from_list 
  let opposite_grapheme = case dict.get(opposite, grapheme) {
    Ok(val) -> val
    Error(_) -> ""
  }
  x == opposite_grapheme
}

fn parser(stack acc: List(String), current item: String) {
  let allowed_chars = ["[", "]", "{", "}", "(", ")"]
  use <- bool.guard(when: !list.contains(allowed_chars, item), return: acc)

  case acc {  
    [] -> [item]
    [first, ..rest] -> case is_yin(first, item) {
      True -> rest
      False -> [item, ..acc]
    }
  } 
}

pub fn is_paired(brackets: String) {
    brackets
    |> string.trim
    |> string.to_graphemes
    |> list.fold([], parser) == []
}
