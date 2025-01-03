defmodule Day16 do
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

  def trace(grid, path) do
    for {p, _} <- path, reduce: grid do
      g -> Map.put(g, p, ?@)
    end
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

    {cost, _path} =
      Search.a_star([{start, :E}], fn {p, _dir} -> p == finish end, fn n -> moves(grid, n) end)

    IO.inspect(cost)
    # traced = trace(grid, path)

    cost_paths =
      Search16.a_star([{start, :E}], fn {p, _dir} -> p == finish end, cost, fn n ->
        moves(grid, n)
      end)

    IO.puts(cost_paths |> Enum.count())

    traced =
      for {_cost, path} <- cost_paths, reduce: grid do
        g -> trace(g, path)
      end

    Util.print_grid(traced, wh)
    IO.puts(for({p, ?@} <- traced, do: p) |> Enum.count())
  end
end
