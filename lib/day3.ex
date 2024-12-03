# https://adventofcode.com/2024/day/3
defmodule Day3 do
  def parse_line(line) do
    String.split(line)
  end

  def main(input_file) do
    txt = File.read!(input_file)
    # Pull out numbers from txt using a regular expression.
    matches = Regex.scan(~r/mul\((\d+),(\d+)\)/, txt)

    part1 =
      matches
      |> Enum.map(fn [_, a, b] -> {String.to_integer(a), String.to_integer(b)} end)
      |> Enum.map(fn {a, b} -> a * b end)
      |> Enum.sum()

    IO.puts(part1)
  end
end
