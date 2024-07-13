import gleam/list 

pub fn place_location_to_treasure_location(
  place_location: #(String, Int),
) -> #(Int, String) {
  let #(place, location) = place_location
  #(location, place)
}


pub fn treasure_location_matches_place_location(
  place_location: #(String, Int),
  treasure_location: #(Int, String),
) -> Bool {
  let #(place, location) = treasure_location
  place_location == #(location, place)
}

pub fn count_place_treasures(
  _place: #(String, #(String, Int)),
  treasures: List(#(String, #(Int, String))),
) -> Int {
  treasures
  |> list.length
}

pub fn special_case_swap_possible(
  found_treasure: #(String, #(Int, String)),
  place: #(String, #(String, Int)),
  desired_treasure: #(String, #(Int, String)),
) -> Bool {
  case found_treasure.0 {
    "Brass Spyglass" -> True
    "Amethyst Octopus" -> case desired_treasure.0 {
      "Crystal Crab" -> True
      "Glass Starfish" -> True
      _ -> False
    }
    "Vintage Pirate Hat" -> case place.0  {
      "Harbor Managers Office" -> case desired_treasure.0 {
        "Antique Glass Fishnet Float" -> True
        "Model Ship in Large Bottle" -> True
        _ -> False
      }
      _ -> False
    }
    _ -> False
  }
}
