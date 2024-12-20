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

  def make_grid(poss, n_bytes) do
    for pos <- Enum.take(poss, n_bytes), reduce: %{} do
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

  def can_solve(instrs, n_bytes) do
    grid = make_grid(instrs, n_bytes)
    target = {@maxval, @maxval}
    cost = Search.a_star([{0, 0}], &(&1 == target), fn p -> neighbors(p, grid) end)

    if cost == nil do
      Util.inspect(Enum.take(instrs, n_bytes) |> Enum.at(-1))
    end

    cost != nil
  end

  def main(input_file) do
    instrs = Util.read_lines(input_file) |> Enum.map(&parse_line/1)
    grid = make_grid(instrs, @numbytes)
    Util.print_grid(grid, {@maxval, @maxval})

    target = {@maxval, @maxval}
    {cost, _path} = Search.a_star([{0, 0}], &(&1 == target), fn p -> neighbors(p, grid) end)
    IO.puts(cost)

    # IO.puts("750: #{can_solve(instrs, 750)}")
    # IO.puts("1500: #{can_solve(instrs, 1500)}")
    # true IO.puts("2250: #{can_solve(instrs, 2250)}")
    # IO.puts("2500: #{can_solve(instrs, 2500)}")
    # true IO.puts("2750: #{can_solve(instrs, 2750)}")
    # true IO.puts("2900: #{can_solve(instrs, 2900)}")
    # false IO.puts("3000: #{can_solve(instrs, 3000)}")
    for n <- 2952..2955, do: IO.puts("#{n}: #{can_solve(instrs, n)}")
  end
end
