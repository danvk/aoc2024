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
    Enum.filter(@dirs, fn {dx, dy} -> Map.get(grid, {x + dx, y + dy}) != c end) |> Enum.count()
  end

  def relabel(grid, {w, h}) do
    keys = for x <- 0..w, y <- 0..h, do: {x, y}

    keys
    |> Enum.reduce({?A, %{}}, fn pt, {n, new_grid} ->
      pv = Map.get(new_grid, pt)

      {new_grid, v, next_n} =
        case pv do
          nil -> {Map.put(new_grid, pt, n), n, n + 1}
          _ -> {new_grid, pv, n}
        end

      c = Map.get(grid, pt)
      {x, y} = pt

      new_grid =
        @dirs
        |> Enum.reduce(new_grid, fn {dx, dy}, new_grid ->
          npt = {x + dx, y + dy}

          if Map.get(grid, npt) == c do
            Map.put(new_grid, npt, v)
          else
            new_grid
          end
        end)

      {next_n, new_grid}
    end)
    |> Util.second()
  end

  def main(input_file) do
    {grid, wh} = Util.read_grid(input_file)
    Util.print_grid(grid, wh)

    IO.puts("---")
    grid = relabel(grid, wh)
    Util.print_grid(grid, wh)

    by_crop =
      Enum.group_by(Map.to_list(grid), &Util.second(&1))
      |> Util.map_values(fn _k, v -> v |> Enum.map(&Util.first/1) end)

    # Util.inspect(by_crop)

    areas = Util.map_values(by_crop, fn _k, v -> Enum.count(v) end)
    # Util.inspect(areas)

    perims =
      Util.map_values(by_crop, fn _c, pts ->
        pts |> Enum.map(&perim(grid, &1)) |> Enum.sum()
      end)

    # Util.inspect(perims)

    Util.inspect(Map.new(areas, fn {k, area} -> {List.to_string([k]), {area, perims[k]}} end))

    part1 = areas |> Enum.map(fn {k, area} -> area * perims[k] end) |> Enum.sum()
    IO.puts("part 1: #{part1}")
  end
end
