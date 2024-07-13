import gleam/bool
import gleam/int
import gleam/io
import gleam/list

pub type Frame {
  Frame(rolls: List(Int), bonus: List(Int))
}

pub type Game {
  Game(frames: List(Frame))
}

pub type Error {
  InvalidPinCount
  GameComplete
  GameNotComplete
}

pub type FrameRollError {
  InvalidFrameRollInput
}

fn is_invalid_roll(r: Int) -> Bool {
  r > 10 || r < 0
}

fn produce_frames_without_bonus(acc: List(Frame), roll: Int) -> List(Frame) {
  case roll, acc {
    10, _ -> [Frame([roll], []), ..acc]
    _, [] -> [Frame([roll], []), ..acc]
    _, [Frame([_, _], _), ..] -> [Frame([roll], []), ..acc]
    _, [Frame([r], _), ..rest] if r != 10 -> [Frame([r, roll], []), ..rest]
    _, [Frame([], _), ..] -> [Frame([roll], []), ..acc]
    _, _ -> [Frame([roll], []), ..acc]
  }
}

fn invalid_frame(game: Game, knocked_pins: Int) {
  use <- bool.guard(
    when: game == Game([]),
    return: is_invalid_roll(knocked_pins),
  )
  let assert Game([Frame(rolls, _), ..]) = game
  case list.length(rolls) {
    1 -> {
      let assert [roll] = rolls
      case roll == 10 {
        True -> knocked_pins > 10 || knocked_pins < 0
        False -> {
          let sum = roll + knocked_pins
          sum > 10 || sum < 0
        }
      }
    }
    _ -> False
  }
}

fn check_invalid_last(roll: Int, frames: List(Frame)) {
  case frames {
    [f1, f2, ..] ->
      case f1, f2 {
        Frame([], []), Frame([10], [b]) ->
          case b {
            10 -> False
            _ -> is_invalid_roll(b + roll)
          }

        _, _ -> False
      }
    _ -> False
  }
}

pub fn roll(game: Game, knocked_pins: Int) -> Result(Game, Error) {
  let assert Game(frames) = game

  use <- bool.guard(
    when: case frames {
      [Frame([], []), Frame([_, _], [_]), ..] -> True
      [Frame([], []), Frame([_], []), Frame([_], [_]), ..] -> True
      _ -> False
    },
    return: Error(GameComplete),
  )

  use <- bool.guard(
    when: is_invalid_roll(knocked_pins),
    return: Error(InvalidPinCount),
  )

  use <- bool.guard(
    when: check_invalid_last(knocked_pins, frames),
    return: Error(InvalidPinCount),
  )

  use <- bool.guard(
    when: invalid_frame(game, knocked_pins),
    return: Error(InvalidPinCount),
  )

  let new_frames = case game {
    Game(frames) ->
      case frames {
        [] -> [Frame([knocked_pins], [])]
        _ -> produce_frames_without_bonus(frames, knocked_pins)
      }
  }

  // fix in case of strike last frame
  let new_frames_two = case list.length(new_frames) {
    12 -> {
      let assert [first, _, ..rest] = new_frames
      [Frame([], []), Frame(first.rolls, []), ..rest]
    }
    _ -> new_frames
  }

  // remove empty frames 

  let with_bonus = case new_frames_two {
    [first, ..rest] -> add_bonus(rest, first)
    _ -> new_frames
  }

  let fix_last_frame = case list.length(with_bonus) >= 11 {
    True -> {
      case with_bonus {
        [first, ..rest] -> {
          [Frame([], first.bonus), ..rest]
        }

        _ -> with_bonus
      }
    }

    False -> with_bonus
  }

  case list.length(fix_last_frame) {
    11 ->
      case fix_last_frame {
        [Frame([], []), Frame([0, 0], []), ..] -> Error(GameComplete)
        _ -> Ok(Game(fix_last_frame))
      }
    _ -> Ok(Game(fix_last_frame))
  }
}

fn extract_score(acc: Int, frame: Frame) {
  let assert Frame(rolls, bonus) = frame
  int.sum(rolls) + int.sum(bonus) + acc
}

pub fn score(game: Game) -> Result(Int, Error) {
  let assert Game(frames) = game

  use <- bool.guard(
    when: case frames {
      [Frame([], []), Frame([10], [10]), ..] -> True
      [Frame([_], []), ..] -> True
      [Frame([r1, r2], _), ..] ->
        case r1 + r2 {
          10 -> True
          _ -> False
        }
      _ -> False
    },
    return: Error(GameNotComplete),
  )

  case list.length(frames) < 10 {
    True -> {
      Error(GameNotComplete)
    }
    False ->
      case game {
        Game(frames) ->
          Ok(list.fold(over: frames, from: 0, with: extract_score))
      }
  }
}

/// Takes an acc (start with []) and a frame
fn add_bonus(acc: List(Frame), frame: Frame) -> List(Frame) {
  case acc, frame {
    // three strikes in a row 
    [Frame([rolly], _), Frame([_], [_]), Frame([_], [_]), ..rest],
      Frame(rolls, _) -> {
      case list.length(rolls) {
        1 -> [
          frame,
          Frame([10], [10]),
          Frame([10], [10]),
          Frame([10], [10, 10]),
          ..rest
        ]

        2 -> {
          let assert [x, y] = rolls
          [
            frame,
            Frame([rolly], [x, y]),
            Frame([10], [x, rolly]),
            Frame([10], [10, 10]),
            ..rest
          ]
        }

        _ ->
          case acc {
            [Frame([10], []), Frame([10], [10]), Frame([10], [10]), ..] -> [
              frame,
              Frame([rolly], []),
              Frame([10], [rolly]),
              Frame([10], [10, 10]),
              ..rest
            ]
            _ -> [
              frame,
              Frame([rolly], []),
              Frame([10], []),
              Frame([10], [10]),
              ..rest
            ]
          }
      }
    }

    // two strikes in a row
    [Frame([r], _), Frame([r2], [b2]), ..rest], Frame([ro1, ro2], _) -> [
      Frame([ro1, ro2], []),
      Frame([r], [ro1, ro2]),
      Frame([r2], [ro1, b2]),
      ..rest
    ]
    // one strike 
    [Frame([r], _), ..rest], Frame(rolls, _) -> [
      frame,
      Frame([r], rolls),
      ..rest
    ]
    // one spare
    [Frame([r1, r2], _), ..rest], Frame(rolls, _) ->
      case list.length(rolls) {
        1 -> {
          let assert [x] = rolls
          case r1 + r2 {
            10 -> [frame, Frame([r1, r2], [x]), ..rest]
            _ -> [frame, ..acc]
          }
        }
        2 -> {
          let assert [x, _] = rolls
          case r1 + r2 {
            10 -> [frame, Frame([r1, r2], [x]), ..rest]
            _ -> [frame, ..acc]
          }
        }
        _ -> [frame, ..acc]
      }

    _, _ -> [frame, ..acc]
  }
}
