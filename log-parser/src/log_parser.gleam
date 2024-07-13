import gleam/io
import gleam/option.{Some}
import gleam/regex.{Match}

pub fn is_valid_line(line: String) -> Bool {
  let assert Ok(re) = regex.from_string("\\[(DEBUG|INFO|WARNING|ERROR)\\]")
  regex.check(re, line)
}

// "<=>[DEBUG] <-*~*->[ERROR] Failed to send SMS."

pub fn split_line(line: String) -> List(String) {
  let assert Ok(re) = regex.from_string("<[-~*=]*>")

  regex.split(with: re, content: line)
}

pub fn tag_with_user_name(line: String) -> String {
  let assert Ok(re) = regex.from_string("User\\s+(\\S+)")
  let matches = regex.scan(with: re, content: line)
  io.debug(matches)

  case matches {
    [Match(_, [Some(username), ..]), ..] -> "[USER] " <> username <> " " <> line
    _ -> line
  }
}

pub fn main() {
  io.debug(split_line("hello <> there"))
  io.debug(split_line("hello <*> there"))
}
