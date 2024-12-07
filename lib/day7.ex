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
        # Or is it concat_int(&1, x)?
        all_vals2(xs) |> Enum.flat_map(&[x + &1, x * &1, concat_int(&1, x)]) |> Enum.uniq()
    end
  end

  def main(input_file) do
    instrs = Util.read_lines(input_file) |> Enum.map(&parse_line/1)
    # Util.inspect(instrs)
    Util.inspect(instrs |> Enum.map(&Enum.count(Util.second(&1))) |> Enum.max())
    first = instrs |> tl() |> hd() |> Util.second()
    Util.inspect(first)
    # Util.inspect(all_vals(first |> Enum.reverse()))

    instrs
    |> Enum.filter(fn {target, xs} -> Enum.member?(all_vals(Enum.reverse(xs)), target) end)
    # |> Util.inspect()
    |> Enum.map(&Util.first/1)
    |> Enum.sum()
    |> IO.puts()

    instrs
    |> Enum.filter(fn {target, xs} -> Enum.member?(all_vals2(Enum.reverse(xs)), target) end)
    # |> Util.inspect()
    |> Enum.map(&Util.first/1)
    |> Enum.sum()
    |> IO.puts()

    Util.inspect(concat_int(12, 345))
    t = instrs |> Enum.at(3) |> Util.second()
    Util.inspect(t)
    Util.inspect(all_vals2(t |> Enum.reverse()))
  end
end
