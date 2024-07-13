import gleam/bool
import gleam/dict.{type Dict}
import gleam/option.{type Option, None, Some}

pub type ScoreBoard =
  Dict(String, Int)

pub fn create_score_board() -> ScoreBoard {
  dict.from_list([#("The Best Ever", 1_000_000)])
}

pub fn add_player(
  score_board: ScoreBoard,
  player: String,
  score: Int,
) -> ScoreBoard {
  dict.insert(score_board, player, score)
}

pub fn remove_player(score_board: ScoreBoard, player: String) -> ScoreBoard {
  dict.delete(score_board, player)
}

/// Adds score to existing player score
pub fn update_score(
  score_board: ScoreBoard,
  player: String,
  points: Int,
) -> ScoreBoard {
  use <- bool.guard(
    when: !dict.has_key(score_board, player),
    return: score_board,
  )
  dict.update(score_board, player, fn(opt: Option(Int)) {
    case opt {
      Some(v) -> v + points
      None -> 0
    }
  })
}

pub fn apply_monday_bonus(score_board: ScoreBoard) -> ScoreBoard {
  dict.map_values(score_board, fn(_, v) { v + 100 })
}
