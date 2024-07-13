import gleam/string.{trim}

pub fn message(log_line: String) -> String {
  case trim(log_line) {
    "[ERROR]: " <> rest -> trim(rest)
    "[WARNING]: " <> rest -> trim(rest)
    "[INFO]: " <> rest -> trim(rest)
    _ -> "No level"
  }
}

pub fn log_level(log_line: String) -> String {
  case trim(log_line) {
    "[E" <> _ -> "error"
    "[I" <> _ -> "info"
    "[W" <> _ -> "warning"
    _ -> "No level"
  }
}

pub fn reformat(log_line: String) -> String {
  case trim(log_line) {
    "[ERROR]: " <> rest -> trim(rest) <> " (error)"
    "[WARNING]: " <> rest -> trim(rest) <> " (warning)"
    "[INFO]: " <> rest -> trim(rest) <> " (info)"
    _ -> "No level"
  }
}
