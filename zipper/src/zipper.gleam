pub type Tree(a) {
  Leaf
  Node(value: a, left: Tree(a), right: Tree(a))
}

pub type Crumb(a) {
  LeftCrumb(parent: a, right: Tree(a))
  RightCrumb(parent: a, left: Tree(a))
}

pub opaque type Zipper(a) {
  Zipper(focus: Tree(a), trail: List(Crumb(a)))
}

pub fn to_zipper(tree: Tree(a)) -> Zipper(a) {
  Zipper(focus: tree, trail: [])
}

pub fn to_tree(zipper: Zipper(a)) -> Tree(a) {
  case zipper {
    Zipper(focus: tree, trail: []) -> tree
    zipper ->
      case up(zipper) {
        Ok(parent_zipper) -> to_tree(parent_zipper)
        Error(Nil) -> zipper.focus
      }
  }
}

pub fn value(zipper: Zipper(a)) -> Result(a, Nil) {
  case zipper.focus {
    Node(value: v, ..) -> Ok(v)
    Leaf -> Error(Nil)
  }
}

pub fn up(zipper: Zipper(a)) -> Result(Zipper(a), Nil) {
  case zipper.trail {
    [LeftCrumb(parent: p, right: r), ..rest] ->
      Ok(Zipper(focus: Node(p, zipper.focus, r), trail: rest))
    [RightCrumb(parent: p, left: l), ..rest] ->
      Ok(Zipper(focus: Node(p, l, zipper.focus), trail: rest))
    [] -> Error(Nil)
  }
}

pub fn left(zipper: Zipper(a)) -> Result(Zipper(a), Nil) {
  case zipper.focus {
    Node(value: v, left: l, right: r) ->
      Ok(Zipper(focus: l, trail: [LeftCrumb(v, r), ..zipper.trail]))
    Leaf -> Error(Nil)
  }
}

pub fn right(zipper: Zipper(a)) -> Result(Zipper(a), Nil) {
  case zipper.focus {
    Node(value: v, left: l, right: r) ->
      Ok(Zipper(focus: r, trail: [RightCrumb(v, l), ..zipper.trail]))
    Leaf -> Error(Nil)
  }
}

pub fn set_value(zipper: Zipper(a), value: a) -> Zipper(a) {
  case zipper.focus {
    Node(left: l, right: r, ..) ->
      Zipper(focus: Node(value, l, r), trail: zipper.trail)
    Leaf -> zipper
  }
}

pub fn set_left(zipper: Zipper(a), tree: Tree(a)) -> Result(Zipper(a), Nil) {
  case zipper.focus {
    Node(value: v, right: r, ..) ->
      Ok(Zipper(focus: Node(v, tree, r), trail: zipper.trail))
    Leaf -> Error(Nil)
  }
}

pub fn set_right(zipper: Zipper(a), tree: Tree(a)) -> Result(Zipper(a), Nil) {
  case zipper.focus {
    Node(value: v, left: l, ..) ->
      Ok(Zipper(focus: Node(v, l, tree), trail: zipper.trail))
    Leaf -> Error(Nil)
  }
}
