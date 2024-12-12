# https://adventofcode.com/2024/day/12
defmodule Day12 do
  def main(input_file) do
    {grid, wh} = Util.read_grid(input_file)
    Util.print_grid(grid, wh)

    areas =
      Enum.group_by(Map.to_list(grid), &Util.second(&1))
      |> Map.new(fn {_k, v} -> Enum.count(v) end)

    Util.inspect(areas)
  end
end
