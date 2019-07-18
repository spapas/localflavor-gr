# Greek local flavor

A very simple project for validating 9-digit greek tax numbers and 11-digit greek social security numbers.

## Installation

Just add this to your deps:

```elixir
def deps do
  [
    {:localflavor_gr, github: "spapas/localflavor-gr", app: false}
  ]
end
```

You can also just pick the `lib/validate_gr_tax_num.ex` or `lib/validate_amka.exe` and copy them to your project; you'll be good to go with just that.

## Usage

Really simple:

```elixir
iex(4)> ValidateGrTaxNum.valid("234564611")
false

iex(5)> ValidateGrTaxNum.valid("997073525")
true

iex(6)> ValidateAMKA.valid("52058401523")
false

iex(7)> ValidateAMKA.valid("02058401528")
true
```
