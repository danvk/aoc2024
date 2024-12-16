# https://adventofcode.com/2024/day/14
defmodule Day14 do
  def parse_line(line) do
    [p, v] = line |> String.split(" ")
    [px, py] = p |> String.slice(2..-1//1) |> Util.read_ints(",")
    [vx, vy] = v |> String.slice(2..-1//1) |> Util.read_ints(",")
    {{px, py}, {vx, vy}}
  end

  def main(input_file) do
    instrs = Util.read_lines(input_file) |> Enum.map(&parse_line/1)
    Util.inspect(instrs)
  end
end
