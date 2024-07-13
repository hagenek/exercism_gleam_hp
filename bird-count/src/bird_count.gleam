pub fn today(days: List(Int)) -> Int {
  case days {
    [] -> 0
    [t, ..] -> t
  }
}

pub fn increment_day_count(days: List(Int)) -> List(Int) {
  case days {
    [] -> [1]
    [t, ..days] -> [t + 1, ..days]
  }
}

pub fn has_day_without_birds(days: List(Int)) -> Bool {
  case days {
    [] -> False
    [0, ..] -> True
    [_, ..days] -> has_day_without_birds(days)
  }
}

pub fn total(days: List(Int)) -> Int {
  case days {
    [] -> 0
    [t, ..days] -> t + total(days)
  }
}

pub fn busy_days(days: List(Int)) -> Int {
  case days {
    [] -> 0
    [t, ..days] if t > 4 -> 1 + busy_days(days)
    [_, ..days] -> busy_days(days)
  }
}
