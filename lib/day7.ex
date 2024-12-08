# https://adventofcode.com/2024/day/7
defmodule Day7 do
  def parse_line(line) do
    [ans_str, nums_str] = String.split(line, ":")
    ans = String.to_integer(ans_str)
    nums = String.trim(nums_str) |> Util.read_ints(" ")
    {ans, nums}
  end

  def all_vals(xs) do
    case xs do
      [] -> []
      [x] -> [x]
      [x | xs] -> all_vals(xs) |> Enum.flat_map(&[x + &1, x * &1]) |> Enum.uniq()
    end
  end

  def concat_int(a, b) do
    "#{a}#{b}" |> String.to_integer()
  end

  def all_vals2(xs) do
    case xs do
      [] ->
        []

      [x] ->
        [x]

      [x | xs] ->
        all_vals2(xs) |> Enum.flat_map(&[x + &1, x * &1, concat_int(&1, x)])
    end
  end

  def main(input_file) do
    instrs = Util.read_lines(input_file) |> Enum.map(&parse_line/1)
    Util.inspect(instrs |> Enum.map(&Enum.count(Util.second(&1))) |> Enum.max())
    first = instrs |> tl() |> hd() |> Util.second()
    Util.inspect(first)

    {valid1, invalid1} =
      instrs
      |> Enum.split_with(fn {target, xs} -> Enum.member?(all_vals(Enum.reverse(xs)), target) end)

    part1 =
      valid1
      |> Enum.map(&Util.first/1)
      |> Enum.sum()

    IO.puts("part 1: #{part1}")

    part2 =
      part1 +
        (invalid1
         |> Enum.filter(fn {target, xs} -> Enum.member?(all_vals2(Enum.reverse(xs)), target) end)
         # |> Util.inspect()
         |> Enum.map(&Util.first/1)
         |> Enum.sum())

    IO.puts("part 2: #{part2}")
  end
end
