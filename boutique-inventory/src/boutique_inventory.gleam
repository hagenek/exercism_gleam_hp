import gleam/iterator.{type Iterator}

pub type Item {
  Item(name: String, price: Int, quantity: Int)
}

fn convert_item_to_string(item: Item) {
  case item {
    Item(name, _, _) -> name
  }
}

pub fn item_names(items: Iterator(Item)) -> Iterator(String) {
  items
  |> iterator.map(convert_item_to_string)
}

pub fn cheap(items: Iterator(Item)) -> Iterator(Item) {
  items
  |> iterator.filter(fn(i) { i.price < 30 })
}

pub fn out_of_stock(items: Iterator(Item)) -> Iterator(Item) {
  items
  |> iterator.filter(fn(i) { i.quantity > 0 })
}

pub fn total_stock(items: Iterator(Item)) -> Int {
  items
  |> iterator.fold(
    with: fn(acc: Int, item: Item) { acc + item.quantity },
    from: 0,
  )
}
