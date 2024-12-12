# https://adventofcode.com/2024/day/12
defmodule Day12 do
  @dirs [
    {1, 0},
    {-1, 0},
    {0, 1},
    {0, -1}
  ]

  def perim(grid, xy) do
    c = Map.get(grid, xy)
    {x, y} = xy
    edges = Enum.filter(@dirs, fn {dx, dy} -> Map.get(grid, x + dx, y + dy) != c end)
  end

  def main(input_file) do
    {grid, wh} = Util.read_grid(input_file)
    Util.print_grid(grid, wh)

    by_crop = Enum.group_by(Map.to_list(grid), &Util.second(&1))

    areas =
      by_crop |> Map.new(fn {k, v} -> {k, Enum.count(v)} end)

    perims =
      Util.map_values(by_crop, fn _c, pts ->
        pts |> Enum.map(&perim(grid, &1)) |> Enum.map(&Enum.sum/1)
      end)

    Util.inspect(areas)
    Util.inspect(perims)
  end
end
