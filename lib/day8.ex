# https://adventofcode.com/2024/day/8
defmodule Day8 do
  def antinodes({ax, ay}, {bx, by}, {w, h}) do
    dx = bx - ax
    dy = by - ay

    [{ax - dx, ay - dy}, {bx + dx, by + dy}]
    |> Enum.filter(fn {x, y} -> x >= 0 && y >= 0 && x <= w && y <= h end)
  end

  def antinodes2({ax, ay}, {bx, by}, {w, h}) do
    dx = bx - ax
    dy = by - ay
    as = for i <- 0..max(w, h), do: {ax - i * dx, ay - i * dy}
    bs = for i <- 0..max(w, h), do: {bx + i * dx, by + i * dy}
    (as ++ bs) |> Enum.filter(fn {x, y} -> x >= 0 && y >= 0 && x <= w && y <= h end)
  end

  def main(input_file) do
    {grid, wh} = Util.read_grid(input_file)
    grid = Map.filter(grid, fn {_k, v} -> v != ?. end)

    antennae = Map.to_list(grid) |> Enum.group_by(&Util.second/1, &Util.first/1)

    # Util.print_grid(grid, wh)
    # Util.inspect(antennae)

    part1 =
      antennae
      |> Enum.flat_map(fn {_freq, spots} ->
        Util.pairs(spots) |> Enum.flat_map(fn {a, b} -> antinodes(a, b, wh) end)
      end)
      |> Enum.uniq()

    # Util.inspect(part1)
    Util.inspect(part1 |> Enum.count())

    part2 =
      antennae
      |> Enum.flat_map(fn {_freq, spots} ->
        Util.pairs(spots) |> Enum.flat_map(fn {a, b} -> antinodes2(a, b, wh) end)
      end)
      |> Enum.uniq()

    Util.inspect(part2 |> Enum.count())

    # Util.inspect(antinodes({4, 4}, {5, 2}, wh))
    # Util.inspect(pairs(antennae[?0]))
  end
end
