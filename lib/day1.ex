defmodule Day1 do
  def parse_line(line) do
    String.split(line) |> Enum.map(&String.to_integer/1)
  end

  def main(args) do
    input_file = hd(args)
    lines = Util.read_lines(input_file) |> Enum.map(&parse_line/1)
    firsts = Enum.map(lines, &Enum.at(&1, 0)) |> Enum.sort()
    seconds = Enum.map(lines, &Enum.at(&1, 1)) |> Enum.sort()
    pairs = Enum.zip(firsts, seconds)
    deltas = pairs |> Enum.map(fn {a, b} -> abs(b - a) end)
    IO.inspect(deltas)
    sum = Enum.sum(deltas)
    IO.inspect(sum)
  end
end
