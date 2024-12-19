# https://adventofcode.com/2024/day/18
defmodule Day18 do
  # @maxval 6
  # @numbytes 12
  @maxval 70
  @numbytes 1024

  @dirs [
    {1, 0},
    {-1, 0},
    {0, 1},
    {0, -1}
  ]

  def parse_line(line) do
    [x, y] = Util.read_ints(line, ",")
    {x, y}
  end

  def make_grid(poss) do
    for pos <- Enum.take(poss, @numbytes), reduce: %{} do
      acc -> Map.put(acc, pos, ?#)
    end
  end

  def neighbors(pos, grid) do
    {x, y} = pos
    nexts = for {dx, dy} <- @dirs, do: {x + dx, y + dy}

    nexts
    |> Enum.filter(fn {x, y} -> x >= 0 && y >= 0 && x <= @maxval && y <= @maxval end)
    |> Enum.filter(fn p -> Map.get(grid, p) == nil end)
    |> Enum.map(&{1, &1})
  end

  def main(input_file) do
    instrs = Util.read_lines(input_file) |> Enum.map(&parse_line/1)
    grid = make_grid(instrs)
    Util.print_grid(grid, {@maxval, @maxval})

    target = {@maxval, @maxval}
    cost = Search.a_star([{0, 0}], &(&1 == target), fn p -> neighbors(p, grid) end)
    IO.puts(cost)
  end
end
