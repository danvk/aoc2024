# https://adventofcode.com/2024/day/15
defmodule Day15 do
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

  def score(grid) do
    Enum.map(grid, fn {{x, y}, v} ->
      case v do
        ?O -> 100 * y + x
        ?. -> 0
        ?# -> 0
        ?] -> 0
        ?[ -> 100 * y + x
      end
    end)
    |> Enum.sum()
  end

  # If the tile is #, the new map contains ## instead.
  # If the tile is O, the new map contains [] instead.
  # If the tile is ., the new map contains .. instead.
  # If the tile is @, the new map contains @. instead.

  def widen(grid) do
    for {{x, y}, c} <- grid, reduce: %{} do
      g ->
        case c do
          ?# -> ~c'##'
          ?O -> ~c'[]'
          ?. -> ~c'..'
          ?@ -> ~c'@.'
        end
        |> Enum.with_index()
        |> Enum.reduce(g, fn {c, i}, g -> Map.put(g, {2 * x + i, y}, c) end)
    end
  end

  def move2(grid, {x, y}, dir) do
    {dx, dy} = delta_for_dir(dir)
    npos = {x + dx, y + dy}
    n = Map.get(grid, npos)
    # IO.inspect({"move2", npos}, charlists: false)

    case n do
      ?# -> {grid, {x, y}}
      ?. -> {grid, npos}
      ?[ -> shove2(grid, {x, y}, {dx, dy})
      ?] -> shove2(grid, {x, y}, {dx, dy})
    end
  end

  def shove2(grid, p, d) do
    if can_shove2(grid, p, d) do
      {dx, dy} = d
      {x, y} = p
      n = {x + dx, y + dy}
      {do_shove2(grid, p, d), n}
    else
      {grid, p}
    end
  end

  def can_shove2(grid, {x, y}, d) do
    {dx, dy} = d
    n = {x + dx, y + dy}
    c = Map.get(grid, n)
    # Util.inspect("can_shove2", {{x, y}, d, c})

    case {c, dy == 0} do
      {?., _} -> true
      {?#, _} -> false
      # Any way to consolidate these cases?
      {?[, true} -> can_shove2(grid, n, d)
      {?], true} -> can_shove2(grid, n, d)
      {?[, false} -> can_shove2(grid, n, d) and can_shove2(grid, {x + dx + 1, y + dy}, d)
      {?], false} -> can_shove2(grid, n, d) and can_shove2(grid, {x + dx - 1, y + dy}, d)
    end
  end

  def do_shove2(grid, {x, y}, d) do
    {dx, dy} = d
    n = {x + dx, y + dy}
    c = Map.get(grid, n)
    cur = Map.get(grid, {x, y})

    case {c, dy == 0} do
      {?., _} -> grid
      {?#, _} -> raise("can/do mismatch #{x}, #{y}, #{dx}, #{dy}")
      # Any way to consolidate these cases?
      {?[, true} -> do_shove2(grid, n, d)
      {?], true} -> do_shove2(grid, n, d)
      {?[, false} -> do_shove2(grid, n, d) |> do_shove2({x + dx + 1, y + dy}, d)
      {?], false} -> do_shove2(grid, n, d) |> do_shove2({x + dx - 1, y + dy}, d)
    end
    |> Map.put(n, cur)
    |> Map.put({x, y}, ?.)
  end

  def main(input_file) do
    {grid_str, moves} = Util.read_lines(input_file) |> Util.split_on_blank()
    {raw_grid, wh} = Util.read_grid_from_lines(grid_str)
    moves = moves |> Enum.join()
    {grid, start} = Util.find_and_replace_char_in_grid(raw_grid, ?@, ?.)
    Util.print_grid(grid, wh)
    Util.inspect(start)
    Util.inspect(moves)

    {shoved_grid, pos} =
      Enum.reduce(String.to_charlist(moves), {grid, start}, fn move, {g, p} ->
        move1(g, p, move)
      end)

    Util.print_grid(shoved_grid, wh)
    Util.inspect(pos)
    Util.inspect(score(shoved_grid))

    raw_grid2 = widen(raw_grid)
    wh2 = {elem(wh, 0) * 2, elem(wh, 1)}
    {grid2, start2} = Util.find_and_replace_char_in_grid(raw_grid2, ?@, ?.)

    Util.print_grid(grid2, wh2)
    Util.inspect(start2)

    {shoved_grid2, pos2} =
      Enum.reduce(String.to_charlist(moves), {grid2, start2}, fn move, {g, p} ->
        move2(g, p, move)
        # n = move2(g, p, move)
        # {g2, p2} = n
        # IO.puts("")
        # Util.print_grid(Map.put(g2, p2, ?@), wh2)
        # n
      end)

    Util.print_grid(shoved_grid2, wh2)
    Util.inspect(pos2)
    Util.inspect(score(shoved_grid2))
  end
end
