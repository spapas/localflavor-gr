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

## Usage

There's only one:

```elixir
iex(4)> ValidateGrTaxNum.valid("129354600")
true

iex(5)> ValidateGrTaxNum.valid("997073525")
true
```
