defmodule ValidateGrTaxNum do
  @moduledoc """
  Documentation for ValidateGrTaxNum.
  """

  @doc """
  Validates a greek tax number.

  ## Examples

      iex> ValidateGrTaxNum.valid("000000000")
      false

      iex> ValidateGrTaxNum.valid("000000001")
      false

      iex> ValidateGrTaxNum.valid("094277965")
      true

      iex> ValidateGrTaxNum.valid("094 27796 5")
      true

      iex> ValidateGrTaxNum.valid("094-27796-5")
      true

      iex> ValidateGrTaxNum.valid("09427796")
      false

      iex> ValidateGrTaxNum.valid("094 27796 a")
      false

  """
  def valid(val) do
    all_digits =
      try do
        val
        |> String.replace(~r/[ -]/, "")
        |> String.graphemes()
        |> Enum.map(&String.to_integer/1)
      rescue
        ArgumentError -> []
      end

    if length(all_digits) != 9 || all_digits |> Enum.sum() == 0 do
      false
    else
      {check, digits} =
        all_digits
        |> Enum.reverse()
        |> List.pop_at(0)

      tmp_check =
        digits
        |> Enum.with_index()
        |> Enum.map(fn {d, idx} -> (d * :math.pow(2, idx + 1)) |> round end)
        |> Enum.sum()
        |> rem(11)

      check ==
        case tmp_check do
          10 -> 0
          v -> v
        end
    end
  end
end
