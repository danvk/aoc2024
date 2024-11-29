defmodule Day3 do
  def part1 do
    IO.puts "part1"
  end

  def part2 do
    IO.puts "part2"
  end

  def is_valid([a, b, c]) do
    a + b > c and a + c > b and b + c > a
  end
end

input_file = hd(System.argv())
instrs = Common.read_lines(input_file)
  |> Enum.map(&String.split/1)
  |> Enum.map(&Enum.map(&1, fn s -> String.to_integer(s) end))

part1valid = instrs |> Enum.filter(&Day3.is_valid/1)
# IO.inspect(instrs)
IO.puts(part1valid |> Enum.count())
