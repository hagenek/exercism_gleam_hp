import gleam/bool
import gleam/int
import gleam/list
import gleam/option.{Some}
import gleam/regex.{type Match, Match}
import gleam/string

pub type Forth {
  Forth(stack: List(Int))
}

pub type ForthError {
  DivisionByZero
  StackUnderflow
  InvalidWord
  UnknownWord
}

pub type ParsingError {
  UnknownOperation
  MultipleMatches
  NoDigits
}

pub type Operation {
  ADD
  SUBTRACT
  MULTIPLY
  DIVIDE
}

pub fn parse_matches(matches: List(Match)) -> Result(List(Int), ParsingError) {
  let int_list =
    matches
    |> list.filter_map(fn(match) {
      case match {
        Match(_, [Some(value)]) -> int.parse(value)
        _ -> Error(Nil)
      }
    })
  case int_list {
    [] -> Error(NoDigits)
    _ -> Ok(int_list)
  }
}

fn extract_digits(input: String) -> Result(List(Int), ParsingError) {
  let assert Ok(re) = regex.from_string("(?<!\\S)(-?\\d+)(?!\\S)")

  regex.scan(with: re, content: input)
  |> parse_matches
}

fn extract_operation(input: String) -> Result(Operation, ParsingError) {
  let assert Ok(re) = regex.from_string("[\\*\\-\\+\\/]")

  let matches = regex.scan(with: re, content: input)

  case matches {
    [Match(val, [])] ->
      case val {
        "*" -> Ok(MULTIPLY)
        "-" -> Ok(SUBTRACT)
        "/" -> Ok(DIVIDE)
        "+" -> Ok(ADD)
        _ -> Error(UnknownOperation)
      }
    _ -> Error(MultipleMatches)
  }
}

pub fn new() -> Forth {
  Forth([])
}

pub fn format_stack(f: Forth) -> String {
  let Forth(stack) = f
  stack
  |> list.map(int.to_string)
  |> string.join(" ")
}

fn add(acc: Int, b: Int) {
  acc + b
}

fn subtract(acc: Int, b: Int) {
  case acc {
    0 -> b
    _ -> acc - b
  }
}

fn divide(acc: Int, b: Int) -> Int {
  case acc {
    0 -> b
    _ -> acc / b
  }
}

fn multiply(acc: Int, b: Int) {
  case acc {
    0 -> b
    _ -> acc * b
  }
}

fn list_contains_zero(l: List(Int)) {
  list.any(l, fn(n: Int) { n == 0 })
}

fn do_operation(
  stack: List(Int),
  operation: Operation,
) -> Result(Forth, ForthError) {
  case operation {
    ADD -> Ok(Forth(stack: [list.fold(stack, 0, add)]))

    SUBTRACT -> Ok(Forth(stack: [list.fold(stack, 0, subtract)]))

    DIVIDE ->
      case list_contains_zero(stack) {
        False -> Ok(Forth(stack: [list.fold(stack, 0, divide)]))
        True -> Error(DivisionByZero)
      }

    MULTIPLY -> Ok(Forth(stack: [list.fold(stack, 0, multiply)]))
  }
}

fn invalid_digits(digits: Result(List(Int), ParsingError)) {
  case digits {
    Error(_) -> True
    Ok(val) -> list.length(val) < 2
  }
}

// multiple programs,each with their own stack. The invalid_digits are only for the first "sequence"
// the next sequence can include only one number on the stack
/// We need to split the program on each operation, so that it actually becomes
pub fn eval(f: Forth, prog: String) -> Result(Forth, ForthError) {
  let digits = extract_digits(prog)
  let operation = extract_operation(prog)

  use <- bool.guard(when: invalid_digits(digits), return: Error(StackUnderflow))

  case operation, digits {
    Ok(operation), Ok(digits) -> do_operation(digits, operation)
    _, Ok(digits) -> Ok(Forth(digits))
    _, Error(_) -> Error(DivisionByZero)
  }
}

pub fn main() {
  extract_digits("-1 -2 -3 4")
}
