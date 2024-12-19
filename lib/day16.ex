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

    cost =
      Search.a_star([{start, :E}], fn {p, _dir} -> p == finish end, fn n -> moves(grid, n) end)

    IO.inspect(cost)
  end
end
