import gleam/int

pub type AddWordDivBy {
  Three
  Five
  Seven
}

fn add_word(number: Int, div_by: AddWordDivBy) -> String {
  let div_by_as_int = case div_by {
    Three -> 3
    Five -> 5
    Seven -> 7
  }
  let divisible = number % div_by_as_int == 0

  case divisible {
    True -> case div_by {
      Three -> "Pling"
      Five -> "Plang"
      Seven -> "Plong"
    }
    False -> ""
  }
}
 
pub fn convert(number: Int) -> String {
  let add_word = add_word(number, _)
  let word_string = add_word(Three) <> add_word(Five) <> add_word(Seven)
  case word_string {
    "" -> int.to_string(number)
    _ -> word_string
  }
}
