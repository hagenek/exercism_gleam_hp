import gleam/string
import gleam/list

pub fn is_isogram(phrase phrase: String) -> Bool {
  let phrase_stripped = string.replace(phrase, "-", "")
    |> string.replace(" ", "")
  
  string.lowercase(phrase_stripped) 
    |> string.to_graphemes
    |> list.unique 
    |> list.length 
    == string.length(phrase_stripped)
}
