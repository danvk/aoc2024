defmodule Day16 do
  def a_star(starts, target, neighbors_fn) do
    queue = starts |> Enum.map(&{0, &1})
    a_star_help(queue, target, %{}, neighbors_fn)
  end

  def a_star_help([], _, _, _) do
    nil
  end

  def a_star_help(queue, target, visited, n_fn) do
    # TODO: heap pop
    [{d, v} | rest] = queue

    cond do
      v == target ->
        d

      Map.get(visited, v) ->
        a_star_help(rest, target, visited, n_fn)

      true ->
        nexts = n_fn.(v)
        d_nexts = nexts |> Enum.map(fn {nd, nv} -> {d + nd, nv} end)
        # TODO: heap push
        next_queue = (d_nexts ++ queue) |> Enum.sort(fn {d1, _}, {d2, _} -> d1 < d2 end)
        next_visited = Map.put(visited, v, d)
        a_star_help(rest, next_queue, next_visited, n_fn)
    end
  end

  def moves(grid, {p, dir}) do
    # (maybe) move one step in dir at a cost of 1
    # (definitely) try all turns at a cost of 1000
    next = Util.move(p, dir)
    next_cell = grid[next]

    step_moves =
      case next_cell do
        ?. -> [{1, next}]
        ?# -> []
      end

    turn_moves = [
      {1000, Util.turn(dir, :L)},
      {1000, Util.turn(dir, :R)}
    ]

    step_moves ++ turn_moves
  end

  def main(input_file) do
    {grid, wh} = Util.read_grid(input_file)
    {grid, start} = Util.find_and_replace_char_in_grid(grid, ?S, ?.)
    {grid, finish} = Util.find_and_replace_char_in_grid(grid, ?E, ?.)

    Util.print_grid(grid, wh)
    Util.inspect(start, finish)

    cost = a_star([{start, :E}], finish, fn n -> moves(grid, n) end)
  end
end
