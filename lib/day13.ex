# https://adventofcode.com/2024/day/13
defmodule Day13 do
  def parse_line(lines) do
    case lines do
      ["Button A: X+#{ax}, Y+#{ay}", "Button B: X+#{bx}, Y+#{by}", "Prize: X=#{px}, Y=#{py}"] ->
        {{ax, ay}, {bx, by}, {px, py}}
    end
  end

  def main(input_file) do
    instrs = Util.read_lines(input_file) |> Util.split_on("")
    Util.inspect(instrs)
  end
end
