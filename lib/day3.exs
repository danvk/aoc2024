defmodule Day3 do
  def part1 do
    IO.puts "part1"
  end

  def part2 do
    IO.puts "part2"
  end
end

input_file = hd(System.argv())
instrs = Common.read_lines(input_file) |> Enum.map(&String.to_charlist/1)
IO.inspect(instrs)
