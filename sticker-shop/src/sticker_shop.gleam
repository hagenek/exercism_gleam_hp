import gleam/list

// Please define the Usd type
pub type Usd

// Please define the Eur type
pub type Eur

// Please define the Jpy type
pub type Jpy

// Please define the Money type
pub opaque type Money(unit) {
  Money(amount: Int)
}

pub fn dollar(amount: Int) -> Money(Usd) {
  Money(amount)
}

pub fn euro(amount: Int) -> Money(Eur) {
  Money(amount)
}

pub fn yen(amount: Int) -> Money(Jpy) {
  Money(amount)
}

pub fn total(prices: List(Money(currency))) -> Money(currency) {
  prices
  |> list.fold(Money(0), fn(acc: Money(currency), money: Money(currency)) {
    Money(money.amount + acc.amount)
  })
}
