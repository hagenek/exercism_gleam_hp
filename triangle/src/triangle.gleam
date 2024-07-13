fn valid_triangle(a: Float, b: Float, c: Float) -> Bool {
  a +. b >. c && a +. c >. b && b +. c >. a
}

pub fn equilateral(a: Float, b: Float, c: Float) -> Bool {
  case valid_triangle(a, b, c) {
    True -> a == b && b == c
    False -> False
  }
}

pub fn isosceles(a: Float, b: Float, c: Float) -> Bool {
  case valid_triangle(a, b, c) {
    True -> a == b || b == c || a == c
    False -> False
  }
}

pub fn scalene(a: Float, b: Float, c: Float) -> Bool {
  case valid_triangle(a, b, c) {
    True -> a != b && b != c && a != c
    False -> False
  }
}
