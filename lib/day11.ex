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

  def blink_map(stones) do
    news = stones |> Enum.flat_map(fn {v, count} -> blink1(v) |> Enum.map(&{&1, count}) end)

    news
    |> Enum.reduce(%{}, fn {v, count}, acc ->
      Util.get_and_update(acc, v, fn old -> (old || 0) + count end)
    end)
  end

  def main(input_file) do
    stones = File.read!(input_file) |> String.trim_trailing() |> Util.read_ints(" ")

    new_stones = 1..25 |> Enum.reduce(stones, fn _, acc -> blink(acc) end)
    part1 = new_stones |> Enum.count()
    IO.puts("part 1: #{part1}")
    stone_map = for stone <- stones, into: %{}, do: {stone, 1}
    new_stones = 1..75 |> Enum.reduce(stone_map, fn _, acc -> blink_map(acc) end)
    part2 = new_stones |> Enum.map(&Util.second/1) |> Enum.sum()
    IO.puts("part 2: #{part2}")
  end
end
