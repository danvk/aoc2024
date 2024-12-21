# https://adventofcode.com/2024/day/20
defmodule Day20 do
  @dirs [
    {1, 0},
    {-1, 0},
    {0, 1},
    {0, -1}
  ]

  defp neighbors(pos, grid) do
    {x, y} = pos
    nexts = for {dx, dy} <- @dirs, do: {x + dx, y + dy}

    nexts
    |> Enum.filter(fn p -> Map.get(grid, p) != ?# end)
    |> Enum.map(&{1, &1})
  end

  defp diamond({x, y}, d) do
    for dy <- -d..d,
        dx <- (-d + abs(dy))..(d - abs(dy)),
        do: {x + dx, y + dy}
  end

  defp find_cheat_ends(grid, cheat_start, d_to_start, d_to_finish, max_d, max_cheat) do
    d = d_to_start[cheat_start]
    # walls = all_wall_neighbors(cheat_start, grid)
    {x, y} = cheat_start
    walls = for {dx, dy} <- @dirs, do: {x + dx, y + dy}

    walls
    |> Enum.flat_map(fn wall ->
      diamond(wall, max_cheat - 1)
      |> Enum.filter(fn e -> Map.get(grid, e) == ?. end)
      |> Enum.map(fn cheat_end ->
        {1 + d + Util.l1_dist(wall, cheat_end) +
           Map.get(d_to_finish, cheat_end, 140 * 140), cheat_start, cheat_end}
      end)
    end)
    |> Enum.filter(fn {d, _, _} -> d <= max_d end)
    |> Enum.group_by(fn {_d, cs, ce} -> {cs, ce} end, fn {d, _cs, _ce} -> d end)
    |> Util.map_values(fn _cheat, ds -> Enum.min(ds) end)
    |> Enum.map(fn {{cs, ce}, d} -> {d, cs, ce} end)
  end

  def main(input_file) do
    {raw_grid, _wh} = Util.read_grid(input_file)
    {grid, start} = Util.find_and_replace_char_in_grid(raw_grid, ?S, ?.)
    {grid, finish} = Util.find_and_replace_char_in_grid(grid, ?E, ?.)

    {cost, path} = Search.a_star([start], &(&1 == finish), fn p -> neighbors(p, grid) end)
    IO.puts("Full time: #{cost} picoseconds")

    d_to_start = Search.flood_fill([start], fn p -> neighbors(p, grid) end)
    d_to_finish = Search.flood_fill([finish], fn p -> neighbors(p, grid) end)
    cheat_starts = path
    IO.puts("Num cheat starts: #{Enum.count(cheat_starts)}")

    part1 =
      cheat_starts
      |> Enum.flat_map(fn cs ->
        find_cheat_ends(grid, cs, d_to_start, d_to_finish, cost - 100, 2)
      end)
      |> Enum.uniq()
      |> Enum.count()

    IO.puts("Part 1: #{part1}")

    part2 =
      cheat_starts
      |> Enum.flat_map(fn cs ->
        find_cheat_ends(grid, cs, d_to_start, d_to_finish, cost - 100, 20)
      end)
      |> Enum.uniq()
      |> Enum.count()

    IO.puts("Part 2: #{part2}")
  end
end
