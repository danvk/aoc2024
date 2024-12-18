defmodule Day16 do
  def a_star(starts, target, neighbors_fn) do
    queue =
      starts
      |> Enum.map(fn start -> {0, start} end)
      |> Enum.into(Heap.new(fn {d1, _}, {d2, _} -> d1 < d2 end))

    a_star_help(queue, target, %{}, neighbors_fn)
  end

  def a_star_help(queue, target, visited, n_fn) do
    # Util.inspect(queue |> Enum.into([]))

    cond do
      Heap.empty?(queue) -> nil
      true -> a_star_help2(queue, target, visited, n_fn)
    end
  end

  def a_star_help2(queue, target, visited, n_fn) do
    {{d, v}, rest} = Heap.split(queue)
    # Util.inspect(d, v)

    cond do
      target.(v) ->
        d

      Map.get(visited, v) ->
        a_star_help(rest, target, visited, n_fn)

      true ->
        nexts = n_fn.(v)
        # IO.inspect(nexts)
        d_nexts = nexts |> Enum.map(fn {nd, nv} -> {d + nd, nv} end)
        # IO.inspect(d_nexts)
        next_queue = d_nexts |> Enum.reduce(rest, fn next, h -> Heap.push(h, next) end)
        # IO.puts("next heap")
        # Util.inspect(next_queue |> Enum.into([]))
        next_visited = Map.put(visited, v, d)
        a_star_help(next_queue, target, next_visited, n_fn)
    end
  end

  def moves(grid, {p, dir}) do
    # (maybe) move one step in dir at a cost of 1
    # (definitely) try all turns at a cost of 1000
    next = Util.move(p, dir)
    next_cell = grid[next]

    step_moves =
      case next_cell do
        ?. -> [{1, {next, dir}}]
        ?# -> []
      end

    turn_moves = [
      {1000, {p, Util.turn(dir, :L)}},
      {1000, {p, Util.turn(dir, :R)}}
    ]

    step_moves ++ turn_moves
  end

  def main(input_file) do
    {grid, wh} = Util.read_grid(input_file)
    {grid, start} = Util.find_and_replace_char_in_grid(grid, ?S, ?.)
    {grid, finish} = Util.find_and_replace_char_in_grid(grid, ?E, ?.)

    Util.print_grid(grid, wh)
    # Util.inspect(start, finish)

    # 1..10
    # |> Enum.shuffle()
    # |> Enum.into(Heap.min())
    # |> Heap.root()
    # |> IO.inspect()

    cost = a_star([{start, :E}], fn {p, _dir} -> p == finish end, fn n -> moves(grid, n) end)
    IO.inspect(cost)
  end
end
