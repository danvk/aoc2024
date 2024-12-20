# https://adventofcode.com/2024/day/20
defmodule Day20 do
  @dirs [
    {1, 0},
    {-1, 0},
    {0, 1},
    {0, -1}
  ]

  def neighbors(pos, grid) do
    {x, y} = pos
    nexts = for {dx, dy} <- @dirs, do: {x + dx, y + dy}

    nexts
    |> Enum.filter(fn p -> Map.get(grid, p) != ?# end)
    |> Enum.map(&{1, &1})
  end

  def wall_neighbors({x, y}, grid, {maxx, maxy}) do
    nexts = for {dx, dy} <- @dirs, do: {x + dx, y + dy}

    nexts
    |> Enum.filter(fn {x, y} -> x > 0 && y > 0 && x < maxx && y < maxy end)
    |> Enum.filter(fn p -> Map.get(grid, p) == ?# end)
  end

  def find_cheat_candidates(path, grid, wh) do
    path |> Enum.flat_map(&wall_neighbors(&1, grid, wh)) |> Enum.uniq()
  end

  def cheat_distance(grid, cheat_pos, start, finish) do
    cheat_grid = Map.put(grid, cheat_pos, ?.)
    {cost, _path} = Search.a_star([start], &(&1 == finish), fn p -> neighbors(p, cheat_grid) end)
    cost
  end

  def main(input_file) do
    {raw_grid, wh} = Util.read_grid(input_file)
    {grid, start} = Util.find_and_replace_char_in_grid(raw_grid, ?S, ?.)
    {grid, finish} = Util.find_and_replace_char_in_grid(grid, ?E, ?.)
    Util.print_grid(grid, wh)
    Util.inspect(start, finish)

    {cost, _path} = Search.a_star([start], &(&1 == finish), fn p -> neighbors(p, grid) end)
    IO.inspect(cost)

    # candidates = find_cheat_candidates(path, grid, wh)

    # Util.inspect(
    #   for(
    #     cheat_pos <- candidates,
    #     do: {cheat_distance(grid, cheat_pos, start, finish), cheat_pos}
    #   )
    #   |> Enum.filter(fn {d, _pos} -> cost - d >= 100 end)
    #   |> Enum.count()
    # )
  end
end
