import gleam/list
import gleam/option.{None, Some}

pub type Tree(a) {
  Tree(label: a, children: List(Tree(a)))
}

pub type Crumb(a) {
  Crumb(parent: a, left_siblings: List(Tree(a)), right_siblings: List(Tree(a)))
}

pub type Zipper(a) {
  Zipper(focus: Tree(a), genealogy: List(Crumb(a)))
}

fn search(zipper: Zipper(a), node: a) -> Result(Zipper(a), Nil) {
  case zipper {
    Zipper(Tree(value, _), _) if value == node -> Ok(zipper)
    _ -> {
      case
        zipper
        |> down
        |> option.from_result
        |> option.then(fn(z) { search(z, node) |> option.from_result })
      {
        Some(z) -> Ok(z)
        None ->
          zipper
          |> right
          |> option.from_result
          |> option.then(fn(z) { search(z, node) |> option.from_result })
          |> option.to_result(Nil)
      }
    }
  }
}

pub fn zipper_to_path(zipper: Zipper(a)) -> List(a) {
  let Zipper(Tree(node, _), genealogy) = zipper
  let parents =
    list.map(genealogy, fn(crumb) {
      let Crumb(parent, _, _) = crumb
      parent
    })
  list.reverse([node, ..parents])
}

fn zip(tree: Tree(a)) -> Zipper(a) {
  Zipper(tree, [])
}

fn down(zipper: Zipper(a)) -> Result(Zipper(a), Nil) {
  case zipper {
    Zipper(Tree(value, [child, ..children]), genealogy) -> {
      Ok(Zipper(child, [Crumb(value, [], children), ..genealogy]))
    }
    _ -> Error(Nil)
  }
}

pub fn up(zipper: Zipper(a)) -> Result(Zipper(a), Nil) {
  case zipper {
    Zipper(tree, [Crumb(parent, left, right), ..grandparents]) -> {
      Ok(Zipper(Tree(parent, list.append(left, [tree, ..right])), grandparents))
    }
    _ -> Error(Nil)
  }
}

pub fn left(zipper: Zipper(a)) -> Result(Zipper(a), Nil) {
  case zipper {
    Zipper(tree, [Crumb(parent, [left, ..lefties], right), ..grandparents]) -> {
      Ok(
        Zipper(left, [Crumb(parent, lefties, [tree, ..right]), ..grandparents]),
      )
    }
    _ -> Error(Nil)
  }
}

pub fn right(zipper: Zipper(a)) -> Result(Zipper(a), Nil) {
  case zipper {
    Zipper(tree, [Crumb(parent, left, [right, ..righties]), ..grandparents]) -> {
      Ok(
        Zipper(right, [Crumb(parent, [tree, ..left], righties), ..grandparents]),
      )
    }
    _ -> Error(Nil)
  }
}

pub fn reparent(zipper: Zipper(a)) -> Tree(a) {
  case zipper {
    Zipper(tree, []) -> tree
    Zipper(Tree(node, children), [Crumb(parent, left, right), ..grandparent]) -> {
      Tree(node, [
        reparent(Zipper(Tree(parent, list.append(left, right)), grandparent)),
        ..children
      ])
    }
  }
}

pub fn from_pov(tree tree: Tree(a), node node: a) -> Result(Tree(a), Nil) {
  case tree |> zip |> search(node) {
    Ok(zipper) -> Ok(reparent(zipper))
    Error(_) -> Error(Nil)
  }
}

pub fn path_to(
  tree tree: Tree(a),
  from from: a,
  to to: a,
) -> Result(List(a), Nil) {
  case tree |> zip |> search(from) {
    Ok(zipper) -> {
      case zipper |> reparent |> zip |> search(to) {
        Ok(zipper_path) -> Ok(zipper_to_path(zipper_path))
        Error(_) -> Error(Nil)
      }
    }
    Error(_) -> Error(Nil)
  }
}
