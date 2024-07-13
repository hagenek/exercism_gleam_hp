// All code here is written in the Gleam programming language
import gleam/int
import gleam/pair
import gleam/list.{filter_map, fold, reverse}

pub type Command {
  Wink
  DoubleBlink
  CloseYourEyes
  Jump
  Reverse
}

pub type InvalidCommand {
  InvalidCommand
}

pub fn decide_command(digit: Int, index: Int) -> Result(Command, InvalidCommand) {
  case digit {
    1 ->
      case index {
        0 -> Ok(Wink)
        1 -> Ok(DoubleBlink)
        2 -> Ok(CloseYourEyes)
        3 -> Ok(Jump)
        4 -> Ok(Reverse)
        _ -> Error(InvalidCommand)
      }
    _ -> Error(InvalidCommand)
  }
}

fn decide_commands(digit_list: List(Int)) -> List(Command) {
  digit_list
  |> fold(#(0, []), fn(acc, item) {
    #(acc.0 + 1, [decide_command(item, acc.0), ..acc.1])
  })
  |> pair.second
  |> filter_map(fn(a) { a })
}

pub fn commands(encoded_message: Int) -> List(Command) {
  let digit_conversion = int.digits(encoded_message, 2)

  let digits = case digit_conversion {
    Ok(val) -> val
    _ -> []
  }

  let command_list = decide_commands(reverse(digits))
  let reversed_list = case list.any(command_list, fn(a) { a == Reverse }) {
    True -> command_list
    False -> reverse(command_list)
  }

  let reversed_removed_list = list.filter(reversed_list, fn(a) { a != Reverse })

  reversed_removed_list
}
