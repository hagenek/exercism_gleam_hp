pub type Approval {
  Yes
  No
  Maybe
}

pub type Cuisine {
  Turkish
  Korean
}

pub type Genre {
  Crime
  Romance
  Horror
  Thriller
} 

pub type Activity {
  BoardGame
  Chill
  Restaurant(Cuisine)
  Walk(Int)
  Movie(Genre)
}

pub fn rate_activity(activity: Activity) -> Approval {
  case activity {
    BoardGame -> No
    Chill -> No
    Movie(genre) -> case genre {
      Crime -> No
      Romance -> Yes
      Horror -> No
      Thriller -> No
    }
    Restaurant(cuisine) -> case cuisine {
      Turkish -> Maybe
      Korean -> Yes 
    }
    Walk(distance) -> case distance > 11 {
      True -> Yes
      False -> case distance > 6 {
        True -> Maybe
        False -> No
      } 
    }
}
}
