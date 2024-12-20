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
    all_wall_neighbors({x, y}, grid)
    |> Enum.filter(fn {x, y} -> x > 0 && y > 0 && x < maxx && y < maxy end)
  end

  def all_wall_neighbors({x, y}, grid) do
    nexts = for {dx, dy} <- @dirs, do: {x + dx, y + dy}

    nexts
    |> Enum.filter(fn p -> Map.get(grid, p) == ?# end)
  end

  def find_cheat_starts(grid, wh) do
    for(
      {{x, y}, ?.} <- grid,
      do: {x, y}
    )
    |> Enum.filter(fn p -> !Enum.empty?(wall_neighbors(p, grid, wh)) end)
  end

  def cheat_distance(grid, cheat_pos, start, finish) do
    cheat_grid = Map.put(grid, cheat_pos, ?.)
    {cost, _path} = Search.a_star([start], &(&1 == finish), fn p -> neighbors(p, cheat_grid) end)
    cost
  end

  def l1_dist({x1, y1}, {x2, y2}), do: abs(x2 - x1) + abs(y2 - y1)

  def diamond({x, y}, d) do
    for dy <- -d..d,
        dx <- (-d + abs(dy))..(d - abs(dy)),
        do: {x + dx, y + dy}
  end

  def find_cheat_ends(grid, wh, cheat_start, d_to_start, d_to_finish, max_d, max_cheat) do
    d = d_to_start[cheat_start]
    walls = wall_neighbors(cheat_start, grid, wh)

    walls
    |> Enum.flat_map(fn wall ->
      diamond(wall, max_cheat - 1)
      |> Enum.filter(fn e -> Map.get(grid, e) == ?. end)
      |> Enum.map(fn cheat_end ->
        {1 + d + l1_dist(wall, cheat_end) +
           Map.get(d_to_finish, cheat_end, 140 * 140), cheat_start, cheat_end}
      end)
    end)
    |> Enum.filter(fn {d, _, _} -> d <= max_d end)

    # Might need to unique by end here.
  end

  def main(input_file) do
    {raw_grid, wh} = Util.read_grid(input_file)
    {grid, start} = Util.find_and_replace_char_in_grid(raw_grid, ?S, ?.)
    {grid, finish} = Util.find_and_replace_char_in_grid(grid, ?E, ?.)
    Util.print_grid(grid, wh)
    Util.inspect(start, finish)

    {cost, _path} = Search.a_star([start], &(&1 == finish), fn p -> neighbors(p, grid) end)
    IO.inspect(cost)

    d_to_start = Search.flood_fill([start], fn p -> neighbors(p, grid) end)
    d_to_finish = Search.flood_fill([finish], fn p -> neighbors(p, grid) end)
    # IO.inspect(Map.new(for {p, d} <- d_to_start, d < 10, do: {p, d}))
    # IO.inspect(d_to_finish[start])

    cheat_starts = find_cheat_starts(grid, wh)
    IO.puts("Num cheat starts: #{Enum.count(cheat_starts)}")

    # cheats =
    #   cheat_starts
    #   |> Enum.flat_map(fn cs ->
    #     find_cheat_ends(grid, wh, cs, d_to_start, d_to_finish, cost - 2, 2)
    #   end)
    #   |> Enum.uniq()

    cheats =
      cheat_starts
      |> Enum.flat_map(fn cs ->
        find_cheat_ends(grid, wh, cs, d_to_start, d_to_finish, cost - 50, 20)
      end)
      |> Enum.uniq()

    Util.inspect(for({d, _cs, _ce} <- cheats, do: cost - d) |> Enum.frequencies())
    Util.inspect(for({8, cs, ce} <- cheats, do: {8, cs, ce}))

    # IO.puts("0")
    # Util.inspect(diamond({0, 0}, 0))
    # IO.puts("1")
    # Util.inspect(diamond({0, 0}, 1))
    # IO.puts("2")
    # Util.inspect(diamond({0, 0}, 2))
    # IO.puts("3")
    # Util.inspect(diamond({0, 0}, 3))

    # cheats =
    #   cheat_starts
    #   |> Enum.flat_map(&find_cheat_ends(grid, &1, distance_to_finish, cost))

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
