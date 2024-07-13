import gleam/list
// Instructions
// Implement the keep and discard operation on collections. Given a collection and a predicate on the collection's elements, keep returns a new collection containing those elements where the predicate is true, while discard returns a new collection containing those elements where the predicate is false.
//
// For example, given the collection of numbers:
//
// 1, 2, 3, 4, 5
// And the predicate:
//
// is the number even?
// Then your keep operation should produce:
//
// 2, 4
// While your discard operation should produce:
//
// 1, 3, 5
// Note that the union of keep and discard is all the elements.
//
// The functions may be called keep and discard, or they may need different names in order to not clash with existing functions or concepts in your language.
//
// Restrictions
// Keep your hands off that filter/reject/whatchamacallit functionality provided by your standard library! Solve this one yourself using other basic tools instead.
//


pub fn keep(list: List(t), predicate: fn(t) -> Bool) -> List(t) {
  case list {
    [] -> []
    [first, ..rest] -> case predicate(first) {
      True -> list.append([first], keep(rest, predicate))
      False -> keep(rest, predicate)
    } 
  }
}

pub fn discard(list: List(t), predicate: fn(t) -> Bool) -> List(t) {
  case list {
    [] -> []
    [first, ..rest] -> case predicate(first) {
      False -> list.append([first], discard(rest, predicate))
      True -> discard(rest, predicate)
    } 
  }
}
