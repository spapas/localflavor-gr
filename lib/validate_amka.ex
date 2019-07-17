defmodule ValidateAMKA do
  @moduledoc """
  A simple module to validate a greek social security number (AMKA).
  24058202672
  A greek SSN has 11 digits; the first six are the date of birth
  of the person. The next four are a number and the last one is
  the checksum digit computed through the luhn algorithm.
  """

  @doc """
  Validates a greek SSN. Just pass a string containing
  integers. It will also accept spaces or dashes between
   the integers but nothing more.

  ## Examples

      iex> ValidateAMKA.valid("00000000000")
      false

      iex> ValidateAMKA.valid("000000001")
      false

      iex> ValidateAMKA.valid("123123123")
      false

      iex> ValidateAMKA.valid("2458202672")
      true

  """
  def valid(val) do
    case val |> covert_to_digits |> get_digits_and_check do
      {check, digits} ->
        # Sum the digits and multiply them by their position-corresponding 2-based power
        # and get their rem with 11
        check ==
          digits
          |> Enum.zip(@multipliers)
          |> Enum.map(fn {x, y} -> x * y end)
          |> Enum.sum()
          |> rem(11)
          # Check if the previous calc is equal to the check digit; If the rem was 10
          # then check if the check digit is 0.
          |> case do
            10 -> 0
            v -> v
          end

      _ ->
        false
    end
  end

  defp get_digits_and_check(all_digits) do
    # If basic checks don't pass then return false
    if length(all_digits) != 11 || Enum.sum(all_digits) == 0 do
      false
    else
      # Return the check digit (last) and the rest of the digits
      all_digits
      |> List.pop_at(8)
    end
  end

  defp covert_to_digits(val) do
    # Convert the digits to integers. If there are forbitten characters
    # return an empty array

    # fix date Regex.replace(~r/(\d\d)(\d\d)(\d\d)/, "250611", "19\\3-\\2-\\1")
    try do
      val
      |> String.replace(~r/[ -]/, "")
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)
    rescue
      ArgumentError -> []
    end
  end
end
