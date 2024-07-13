// If the guess is 42: "Correct"
// If the guess is 41 or 43: "So close"
// If the guess is less than 41: "Too low"
// If the guess is greater than 43: "Too high"

pub fn reply(guess: Int) -> String {
  case guess {
    42 -> "Correct"
    43 -> "So close"
    41 -> "So close"
    i if i < 41 -> "Too low"
    i if i > 41 -> "Too high"
    _ -> "Not a number"
  }
}
