pub fn is_leap_year(year: Int) -> Bool {
  let is_div_by_4 = year % 4 == 0
  let is_div_by_100 = year % 100 == 0
  let is_div_by_400 = year % 400 == 0

  case is_div_by_400 {
    True -> True
    False -> 
      case is_div_by_100 {
        True -> False
        False -> is_div_by_4
      }
  }
}

