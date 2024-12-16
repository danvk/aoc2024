# https://adventofcode.com/2024/day/15
defmodule Day15 do
  def parse_line(line) do
    String.split(line)
  end

  def main(input_file) do
    instrs = Util.read_lines(input_file) |> Enum.map(&parse_line/1)
    Util.inspect(instrs)
  end
end
