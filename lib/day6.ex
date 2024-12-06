# https://adventofcode.com/2024/day/6
defmodule Day6 do
  def find_and_remove_caret(grid) do
    for(
      {p, v} <- grid,
      do:
        if(v == ?^) do
          {Map.put(grid, p, ?.), p}
        else
          nil
        end
    )
    |> Enum.filter(& &1)
    |> hd()
  end

  def print_grid(grid, {w, h}) do
    for y <- 0..h do
      for x <- 0..w do
        # XXX any simpler way to print a single char?
        IO.write(List.to_string([grid[{x, y}]]))
      end

      IO.puts("")
    end
  end

  # Move d units in the direction dir
  def move({x, y}, {dir, d}) do
    case dir do
      :E -> {x + d, y}
      :W -> {x - d, y}
      :N -> {x, y - d}
      :S -> {x, y + d}
    end
  end

  def turn(dir, turn) do
    case {dir, turn} do
      {:E, :R} -> :S
      {:E, :L} -> :N
      {:W, :R} -> :N
      {:W, :L} -> :S
      {:N, :R} -> :E
      {:N, :L} -> :W
      {:S, :R} -> :W
      {:S, :L} -> :E
    end
  end

  def move_one(grid, pos, dir, prev) do
    next_pos = move(pos, {dir, 1})
    next = Map.get(grid, next_pos)

    case next do
      ?. -> {next_pos, dir, Map.put(prev, next_pos, true)}
      ?# -> {pos, turn(dir, :R), prev}
      nil -> {nil, nil, prev}
    end
  end

  def main(input_file) do
    {grid, wh} = Util.read_grid(input_file)
    {grid, pos} = find_and_remove_caret(grid)
    # Util.inspect(grid)
    print_grid(grid, wh)
    Util.inspect(pos)

    dir = :N
    prev = %{}

    loop = fn
      {nil, nil, prev}, _ ->
        prev

      {pos, dir, prev}, fun ->
        fun.(move_one(grid, pos, dir, prev), fun)
    end

    visited = loop.({pos, dir, prev}, loop)
    # IO.inspect(visited)
    IO.puts(visited |> Enum.count())
  end
end
