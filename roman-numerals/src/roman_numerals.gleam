import gleam/int
import gleam/string
import gleam/list
import gleam/result

fn convert_digit(number: Int) -> String {
case number {
    0 -> ""
    1 -> "I"
    2 -> "II"
    3 -> "III"
    4 -> "IV"
    5 -> "V"
    6 -> "VI"
    7 -> "VII"
    8 -> "VIII"
    9 -> "IX"
    _ -> "Not a positive single digit integer"
}
}

fn convert_tens(number: Int) -> String {
case number {
    0 -> ""
    1 -> "X"
    2 -> "XX"
    3 -> "XXX"
    4 -> "XL"
    5 -> "L"
    6 -> "LX"
    7 -> "LXX"
    8 -> "LXXX"
    9 -> "XC"
    _ -> "Not a positive single digit integer"
}
}

fn convert_hundreds(number: Int) -> String {
case number {
    0 -> ""
    1 -> "C"
    2 -> "CC"
    3 -> "CCC"
    4 -> "CD"
    5 -> "D"
    6 -> "DC"
    7 -> "DCC"
    8 -> "DCCC"
    9 -> "CM"
    _ -> "Not a positive single digit integer"
}
}

fn convert_thousands(number: Int) -> String {
case number {
    1 -> "M"
    2 -> "MM"
    3 -> "MMM"
    _ -> "Not a positive single digit integer"
}
}

  fn extract_digit(digits: List(String), at index: Int) -> Int {
    digits
    |> list.at(index)
    |> result.unwrap(or: "NOT_VALID")
    |> int.parse
    |> result.unwrap(or: -1)
}

pub fn convert(number: Int) -> String {

  let number_str = int.to_string(number)
  let decimal_places = string.length(number_str)

  let str_list = string.split(number_str, "") |> list.reverse 

  let last_int = extract_digit(str_list, at:  decimal_places - 1)
  let second_int = extract_digit(str_list, at: decimal_places - 2)
  let third_int = extract_digit(str_list, at: decimal_places - 3)
  let fourth_int = extract_digit(str_list, at: decimal_places - 4)

  case decimal_places {
    1 -> convert_digit(last_int)
    2 -> convert_tens(last_int) <> convert_digit(second_int)
    3 -> convert_hundreds(last_int) <> convert_tens(second_int) <> convert_digit(third_int)
    4 -> convert_thousands(last_int) <> convert_hundreds(second_int) <> convert_tens(third_int) <> convert_digit(fourth_int)
    _ -> "TOO BIG OR TOO SMALL NUMBER"
  }
}
