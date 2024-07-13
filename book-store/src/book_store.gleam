import gleam/int
import gleam/list
import gleam/float

pub type Book = Int
pub type BookSet = List(Book)

fn first_or_empty_list(list: List(BookSet)) -> BookSet {
  case list.first(list) {
    Ok(set) -> set
    Error(_) -> []
  }
}

fn rest_or_empty_list(list: List(BookSet)) -> List(BookSet) {
  case list.rest(list) {
    Ok(rest) -> rest
    Error(_) -> []
  }
}

fn construct_sets(sets: List(BookSet), book: Book) -> List(BookSet) {
  let current_set = first_or_empty_list(sets)
  let rest_sets = rest_or_empty_list(sets)

  case list.contains(current_set, book) {
      True -> case rest_sets {
        [] -> [[book], current_set]
        _ -> [current_set, ..construct_sets(rest_sets, book)]
      }
      False -> [[book, ..current_set], ..rest_sets]
  }
}


fn construct_sets_prio_four(sets: List(BookSet), book: Book) -> List(BookSet) {
  let current_set = first_or_empty_list(sets)
  let rest_sets = rest_or_empty_list(sets)

  case list.contains(current_set, book) {
      True -> case rest_sets {
        [] -> [[book], current_set]
        _ -> [current_set, ..construct_sets_prio_four(rest_sets, book)]
      }
      False -> case list.length(current_set) == 4 {
        True ->  [current_set, ..construct_sets_prio_four(rest_sets, book)]
        False -> [[book, ..current_set], ..rest_sets]
      }
  }
}

pub fn calc_discount(books: Int) -> Float {
  case books {
      1 -> 0.0
      2 -> 0.05
      3 -> 0.10
      4 -> 0.20
      5 -> 0.25
      _ -> 0.0
  }
}

fn calc_price_for_set(set: BookSet) -> Float {
  set
  |> list.length
  |> fn (n: Int) { int.to_float(n) *. 800.0 *. { 1.0 -. calc_discount(n) } }
}

fn group_and_sum(books: List(Int)) {
  let strategy = case float.random() >. 0.5 {
    True -> construct_sets
    False -> construct_sets_prio_four
  }

   books
    |> list.shuffle
    |> list.fold(from: [[]], over: _, with: strategy)
    |> list.map(calc_price_for_set)
    |> float.sum
}

pub fn lowest_price(books: List(Int)) -> Float {
  let alternatives = 
      list.range(from: 0, to: 10)
  |> list.map(fn (_) { books })
  |> list.map(group_and_sum)
  |> list.sort(float.compare)
  
  let assert Ok(first) = list.first(alternatives)
  first
}


