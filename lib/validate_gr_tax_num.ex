defmodule ValidateGrTaxNum do
  @moduledoc """
  A simple module to validate a greek tax number. 
  
  A greek tax number has 9 digits; the last one of 
  them is a checksum digit and the others are used
  to compute that checksum through a rather simple
  algorithm.

  """

  @doc """
  Validates a greek tax number. Just pass a string
  containing integers. It will also accept spaces
  or dashes between the integers but nothing more.

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
    # Convert the digits to integers. If there are forbitten characters
    # return an empty array
    all_digits =
      try do
        val
        |> String.replace(~r/[ -]/, "")
        |> String.graphemes()
        |> Enum.map(&String.to_integer/1)
      rescue
        ArgumentError -> []
      end

    # If basic checks don't pass then return false 
    if length(all_digits) != 9 || all_digits |> Enum.sum() == 0 do
      false
    else
      # Retrieve the check digit and reverse the rest of the digits for easier manipulation
      {check, digits} =
        all_digits
        |> Enum.reverse()
        |> List.pop_at(0)

      # Sum the digits and multiply them by their position-corresponding 2-based power
      # and get their rem with 11
      tmp_check =
        digits
        |> Enum.with_index()
        |> Enum.map(fn {d, idx} -> (d * :math.pow(2, idx + 1)) |> round end)
        |> Enum.sum()
        |> rem(11)

      # Check if the previous calc is equal to the check digit; If the rem was 10 
      # then check if the check digit is 0.
      check ==
        case tmp_check do
          10 -> 0
          v -> v
        end
    end
  end
end
