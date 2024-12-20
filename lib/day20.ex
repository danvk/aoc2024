# https://adventofcode.com/2024/day/20
defmodule Day20 do
  @dirs [
    {1, 0},
    {-1, 0},
    {0, 1},
    {0, -1}
  ]

  defmodule State do
    # cheat_start=nil if the cheat hasn't been used yet.
    # cheat_start is set and cheat_count is a count if the cheat is active.
    # cheat_start and cheat_end are both set if the cheat is complete, and cheat_count is nil.
    defstruct [:pos, cheat_start: nil, cheat_end: nil, cheat_count: nil]
  end

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

  def cheat_neighbors(grid, state, {maxx, maxy}, max_cheat) do
    %State{pos: {x, y}, cheat_start: cheat_start, cheat_end: cheat_end, cheat_count: cheat_count} =
      state

    nexts = for {dx, dy} <- @dirs, do: {x + dx, y + dy}
    cur = Map.get(grid, {x, y})

    nexts
    |> Enum.filter(fn {x, y} -> x > 0 && y > 0 && x < maxx && y < maxy end)
    |> Enum.flat_map(fn p ->
      c = Map.get(grid, p)

      # TODO: factor out the {1, }
      case {c, cheat_start, cheat_end} do
        {?., nil, nil} ->
          [%State{state | pos: p}]

        # optional end of the cheat
        {?., _, nil} when cheat_count < max_cheat - 1 and cur == ?# ->
          [
            %State{state | pos: p, cheat_count: cheat_count + 1},
            %State{state | pos: p, cheat_end: p, cheat_count: nil}
          ]

        # end of the cheat
        {?., _, nil} ->
          [%State{state | pos: p, cheat_end: p, cheat_count: nil}]

        {?., _, _} ->
          [%State{state | pos: p}]

        # start the cheat
        {?#, nil, nil} ->
          [%State{pos: p, cheat_start: p, cheat_count: 1}]

        {?#, _, nil} when cheat_count < max_cheat - 1 ->
          [%State{state | pos: p, cheat_count: cheat_count + 1}]

        {?#, _, _} ->
          []
      end
    end)
    |> Enum.map(&{1, &1})
  end

  def main(input_file) do
    {raw_grid, wh} = Util.read_grid(input_file)
    {grid, start} = Util.find_and_replace_char_in_grid(raw_grid, ?S, ?.)
    {grid, finish} = Util.find_and_replace_char_in_grid(grid, ?E, ?.)
    Util.print_grid(grid, wh)
    Util.inspect(start, finish)

    {full_cost, _path} = Search.a_star([start], &(&1 == finish), fn p -> neighbors(p, grid) end)
    IO.inspect(full_cost)

    IO.puts("Searching through max_d=#{full_cost - 100}")

    cost_paths =
      Search16.a_star([%State{pos: start}], &(&1.pos == finish), full_cost - 100, fn state ->
        cheat_neighbors(grid, state, wh, 20)
      end)

    Util.inspect(for({cost, _p} <- cost_paths, do: full_cost - cost) |> Enum.frequencies())

    Util.inspect(for {c, p} <- cost_paths |> Enum.take(10), do: {c, hd(p)})

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
