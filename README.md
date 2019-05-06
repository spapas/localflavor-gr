# Validate Greek Tax Number

A simple module for validating 9-digit Greek Tax numbers.

## Installation

Just add this to your deps:

```elixir
def deps do
  [
    {:validate_greek_tax_number, github: "spapas/validate_greek_tax_number", app: false}
  ]
end
```

You can also just pick the `lib/validate_gr_tax_num.ex` and copy it to your project; you'll be good to go with just that.

## Usage

There's only one:

```elixir
iex(4)> ValidateGrTaxNum.valid("234564611")
false

iex(5)> ValidateGrTaxNum.valid("997073525")
true
```
