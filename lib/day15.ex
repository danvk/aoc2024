# https://adventofcode.com/2024/day/15
defmodule Day15 do
  def parse_line(line) do
    String.split(line)
  end

  def delta_for_dir(d) do
    case d do
      ?v -> {0, 1}
      ?^ -> {0, -1}
      ?< -> {-1, 0}
      ?> -> {1, 0}
    end
  end

  def move1(grid, {x, y}, dir) do
    {dx, dy} = delta_for_dir(dir)
    npos = {x + dx, y + dy}
    n = Map.get(grid, npos)

    case n do
      ?# -> {grid, {x, y}}
      ?. -> {grid, npos}
      ?O -> shove(grid, {x, y}, {dx, dy})
    end
  end

  def shove(grid, {x, y}, {dx, dy}) do
    n = {x + dx, y + dy}
    no = find_next_open(grid, n, {dx, dy})

    case no do
      nil ->
        {grid, {x, y}}

      o ->
        {
          grid |> Map.put(o, ?O) |> Map.put(n, ?.),
          n
        }
    end
  end

  def find_next_open(grid, {x, y}, {dx, dy}) do
    n = {x + dx, y + dy}
    nv = Map.get(grid, n)

    case nv do
      ?# -> nil
      ?. -> n
      ?O -> find_next_open(grid, n, {dx, dy})
    end
  end

  def main(input_file) do
    {grid_str, moves} = Util.read_lines(input_file) |> Util.split_on_blank()
    {grid, wh} = Util.read_grid_from_lines(grid_str)
    moves = moves |> Enum.join()
    {grid, start} = Util.find_and_replace_char_in_grid(grid, ?@, ?.)
    Util.print_grid(grid, wh)
    Util.inspect(start)
    Util.inspect(moves)

    {grid, pos} =
      Enum.reduce(String.to_charlist(moves), {grid, start}, fn move, {g, p} ->
        move1(g, p, move)
      end)

    Util.print_grid(grid, wh)
    Util.inspect(pos)
  end
end
