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

      #iex> ValidateAMKA.valid("00000000000")
      #false

      #iex> ValidateAMKA.valid("000000001")
      #false

      #iex> ValidateAMKA.valid("123123123")
      #false

      #iex> ValidateAMKA.valid("993123123")
      #false

      iex> ValidateAMKA.valid("21068302673")
      false

      iex> ValidateAMKA.valid("21068302674")
      true

      iex> ValidateAMKA.valid("20108201821")
      true

      iex> ValidateAMKA.valid("02058401528")
      true

      iex> ValidateAMKA.valid("52058401523")
      false


  """
  def valid(val) do
    case val |> covert_to_digits do
      :error ->
        false

      digits ->
        # 1. Reverse the digits and add an index to them
        digits
        |> Enum.reverse
        |> Enum.with_index()  
        # Then sum the digits either as they are or using the luhn_double_digit
        |> Enum.map(fn {d, idx} -> if rem(idx, 2) == 0, do: d, else: luhn_double_digit(d) end)
        |> Enum.sum()
        # And finally check the mod 10 and return true if it is 0
        |> rem(10)
        |> case do
          0 -> true
          _ -> false
        end
    end
  end

  defp luhn_double_digit(d) do
    # This will return the 2*digit as it is if it is < 9 or it will the sum of the digits if it is >= 10
    # i.e 18 = 1+8 = 9
    d2 = d * 2
    if d2 > 9, do: 1+(d2-10), else: d2
  end

  defp is_valid_date(<<d1, d2, m1, m2, y1, y2>>)
       when d1 in ?0..?9 and d2 in ?0..?9 and
              m1 in ?0..?9 and m2 in ?0..?9 and y1 in ?0..?9 and y2 in ?0..?9 do
    # Converting the DDMMYY date thingie to 19YY-MM-DD to pase it to Date.from_iso8601 and check if it is valid:
    # solution 1. Regex.replace(~r/(\d\d)(\d\d)(\d\d)/, "250611", "19\\3-\\2-\\1")
    # solution 2. "250611" |> String.graphemes |> Enum.chunk_every(2) |> Enum.reverse |> Enum.flat_map(& &1) |> List.insert_at(2,"-") |> List.insert_at(5,"-") |> List.insert_at(0, "19") |> Enum.join |> Date.from_iso8601
    # solution 3. <<day :: binary-size(2), month :: binary-size(2), year :: binary-size(2)>> = "250611"
    # solution 4a. ( fn(<<d1, d2, m1, m2, y1, y2>>) -> <<?1, ?9, y1, y2, ?-, m1, m2, ?-, d1, d2>> end ).("230419")
    # solution 4b. (same as with 4a but with guards):
    # (fn(<<d1, d2, m1, m2, y1, y2>>) when  d1 in ?0..?9 and d2 in ?0..?9 and  m1 in ?0..?9 and m2 in ?0..?9 and y1 in ?0..?9 and y2 in ?0..?9 -> <<?1, ?9, y1, y2, ?-, m1, m2, ?-, d1, d2>> end ).("230413")
    <<?1, ?9, y1, y2, ?-, m1, m2, ?-, d1, d2>>
    |> Date.from_iso8601() 
    
  end

  defp covert_to_digits(val) do
    # Convert the digits to integers. If there are forbitten characters
    # return an empty array
    
    okval = val |> String.replace(~r/[ -]/, "")

    case okval |> String.slice(0, 6) |> is_valid_date do
      {:ok, _} ->
        try do
          okval
          |> String.graphemes()
          |> Enum.map(&String.to_integer/1)
        rescue
          ArgumentError -> :error
        end

      _ ->
        :error
    end
  end
end
