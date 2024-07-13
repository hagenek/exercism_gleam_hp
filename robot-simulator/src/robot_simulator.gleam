import gleam/list
import gleam/string

pub type Robot {
  Robot(direction: Direction, position: Position)
}

pub type Direction {
  North
  East
  South
  West
}

pub type Position {
  Position(x: Int, y: Int)
}

pub fn create(direction: Direction, position: Position) -> Robot {
  Robot(direction, Position(position.x, position.y))
}


fn new_direction(direction: Direction, turn: String) -> Direction {
  case direction {
    North -> case turn {
      "L" -> West
      "R" -> East
      _ -> North
    }
    East -> case turn {
      "L" -> North
      "R" -> South
      _ -> East
    }
    South -> case turn {
      "L" -> East
      "R" -> West
      _ -> South
    }
    West -> case turn {
      "L" -> South
      "R" -> North
      _ -> West 
    }
  }
}

fn advance(direction: Direction, position: Position) -> Position {
  case direction {
    North -> Position(position.x, position.y + 1)
    East -> Position(position.x + 1, position.y)
    South -> Position(position.x, position.y - 1)
    West -> Position(position.x - 1, position.y)
  }
}

fn parse_instruction(
  robot: Robot,
  move: String,
) -> Robot {

  let direction = robot.direction
  let position = robot.position

  case move {
    "A" -> create(direction, advance(direction, position))
    "R" -> create(new_direction(direction, "R"), position)
    "L" -> create(new_direction(direction, "L"), position)
    _ -> create(direction, position)
  }
}

pub fn move(
  direction: Direction,
  position: Position,
  instructions: String,
) -> Robot {
  let moves = string.split(instructions, "")
  list.fold(over: moves, from: create(direction, position), with: parse_instruction)
}
