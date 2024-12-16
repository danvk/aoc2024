# https://adventofcode.com/2024/day/15
defmodule Day15 do
  def parse_line(line) do
    String.split(line)
  end

  def main(input_file) do
    {grid_str, moves} = Util.read_lines(input_file) |> Util.split_on_blank()
    {grid, wh} = Util.read_grid_from_lines(grid_str)
    moves = moves |> Enum.join()
    Util.print_grid(grid, wh)

    Util.inspect(moves)
  end
end
