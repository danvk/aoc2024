# https://adventofcode.com/2024/day/11
defmodule Day11 do
  def split(stone) do
    s = "#{stone}"

    [
      String.slice(s, 0, div(String.length(s), 2)),
      String.slice(s, div(String.length(s), 2), String.length(s))
    ]
    |> Enum.map(&String.to_integer/1)
  end

  def blink1(stone) do
    cond do
      stone == 0 -> [1]
      rem(String.length("#{stone}"), 2) == 0 -> split(stone)
      true -> [stone * 2024]
    end
  end

  def blink(stones) do
    Enum.flat_map(stones, &blink1/1)
  end

  def main(input_file) do
    stones = File.read!(input_file) |> String.trim_trailing() |> Util.read_ints(" ")

    new_stones = 1..25 |> Enum.reduce(stones, fn _, acc -> blink(acc) end)
    # Util.inspect(new_stones)
    Util.inspect(new_stones |> Enum.count())
  end
end
