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

  def perim2(grid, xy) do
    c = Map.get(grid, xy)
    {x, y} = xy
    at = fn nx, ny -> Map.get(grid, {nx, ny}) end

    [
      at.(x, y - 1) != c && !(at.(x - 1, y) == c && at.(x - 1, y - 1) != c),
      at.(x, y + 1) != c && !(at.(x + 1, y) == c && at.(x + 1, y + 1) != c),
      at.(x - 1, y) != c && !(at.(x, y - 1) == c && at.(x - 1, y - 1) != c),
      at.(x + 1, y) != c && !(at.(x, y + 1) == c && at.(x + 1, y + 1) != c)
    ]
    |> Enum.filter(& &1)
    |> Enum.count()
  end

  def relabel_help(_grid, [], new_grid, _n) do
    new_grid
  end

  def relabel_help(grid, [pt | rest], new_grid, n) do
    pv = Map.get(new_grid, pt)

    {new_grid, v, next_n} =
      case pv do
        nil -> {Map.put(new_grid, pt, n), n, n + 1}
        _ -> {new_grid, pv, n}
      end

    c = Map.get(grid, pt)
    {x, y} = pt

    {new_pts, new_grid} =
      @dirs
      |> Enum.reduce({[], new_grid}, fn {dx, dy}, {pts, new_grid} ->
        npt = {x + dx, y + dy}
        gridv = Map.get(grid, npt)
        new_gridv = Map.get(new_grid, npt)

        if c == gridv && new_gridv != nil && new_gridv != v do
          raise("Created new plot!")
        end

        if new_gridv == nil && gridv == c do
          {[npt | pts], Map.put(new_grid, npt, v)}
        else
          {pts, new_grid}
        end
      end)

    relabel_help(grid, new_pts ++ rest, new_grid, next_n)
  end

  def relabel(grid, {w, h}) do
    keys = for x <- 0..w, y <- 0..h, do: {x, y}
    relabel_help(grid, keys, %{}, ?A)
  end

  def main(input_file) do
    {grid, wh} = Util.read_grid(input_file)
    # Util.print_grid(grid, wh)

    # IO.puts("---")
    grid = relabel(grid, wh)
    # Util.print_grid(grid, wh)

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
    # Util.inspect(Map.new(areas, fn {k, area} -> {List.to_string([k]), {area, perims[k]}} end))

    part1 = areas |> Enum.map(fn {k, area} -> area * perims[k] end) |> Enum.sum()
    IO.puts("part 1: #{part1}")

    perims2 =
      Util.map_values(by_crop, fn _c, pts ->
        pts |> Enum.map(&perim2(grid, &1)) |> Enum.sum()
      end)

    # Util.inspect(Map.new(areas, fn {k, area} -> {List.to_string([k]), {area, perims2[k]}} end))
    part2 = areas |> Enum.map(fn {k, area} -> area * perims2[k] end) |> Enum.sum()
    IO.puts("part 2: #{part2}")
  end
end
