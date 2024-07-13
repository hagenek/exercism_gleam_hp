import gleam/list

pub opaque type Set(t) {
  Set(items: List(t))
}

pub fn new(members: List(t)) -> Set(t) {
  Set(items: members |> list.unique)
}

pub fn is_empty(set: Set(t)) -> Bool {
  set.items == []
}

pub fn contains(in set: Set(t), this member: t) -> Bool {
  list.contains(set.items, member)
}

pub fn is_subset(first: Set(t), of second: Set(t)) -> Bool {
  case first, second {
    Set(list_one), Set(list_two) -> {
      list_one
      |> list.map(fn(item: t) { list.contains(list_two, item) })
      |> list.all(fn(b) { b })
    }
  }
}

pub fn disjoint(first: Set(t), second: Set(t)) -> Bool {
  first.items
  |> list.map(fn(item: t) { list.contains(second.items, item) })
  |> list.all(fn(b) { !b })
}

pub fn is_equal(first: Set(t), to second: Set(t)) -> Bool {
  is_subset(first, second) && is_subset(second, first)
}

pub fn add(to set: Set(t), this member: t) -> Set(t) {
  case contains(set, member) {
    True -> set
    False -> {
      let Set(coll) = set
      Set([member, ..coll])
    }
  }
}

pub fn intersection(of first: Set(t), and second: Set(t)) -> Set(t) {
  first.items
  |> list.fold([], fn(acc: List(t), item: t) {
    case list.contains(second.items, item) {
      True -> [item, ..acc]
      False -> acc
    }
  })
  |> new
}

pub fn difference(between first: Set(t), and second: Set(t)) -> Set(t) {
  first.items
  |> list.fold([], fn(acc: List(t), item: t) {
    case list.contains(second.items, item) {
      False -> [item, ..acc]
      True -> acc
    }
  })
  |> new
}

pub fn union(of first: Set(t), and second: Set(t)) -> Set(t) {
  list.interleave([first.items, second.items]) |> list.unique |> new
}
