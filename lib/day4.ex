# https://adventofcode.com/2024/day/4
defmodule Day4 do
  def parse_line(line) do
    String.split(line)
  end

  def chars_in_dir(grid, {x, y}, {dx, dy}) do
    Enum.map(0..3, fn i -> grid[{x + i * dx, y + i * dy}] end)
  end

  def main(input_file) do
    grid =
      for {y, line} <- Util.read_lines(input_file) |> Util.enumerate(),
          {x, char} <- line |> String.to_charlist() |> Util.enumerate(),
          into: %{},
          do: {{x, y}, char}

    # IO.inspect(grid)

    dirs = [
      {1, 0},
      {-1, 0},
      {0, 1},
      {0, -1},
      {1, 1},
      {-1, -1},
      {1, -1},
      {-1, 1}
    ]

    w = for({x, _y} <- Map.keys(grid), do: x) |> Enum.max()
    h = for({_x, y} <- Map.keys(grid), do: y) |> Enum.max()
    IO.inspect({w, h})

    part1 =
      for(x <- 0..w, y <- 0..h, dir <- dirs, do: {{x, y}, dir, chars_in_dir(grid, {x, y}, dir)})
      |> Enum.filter(fn {_, _, chars} -> chars == ~c"XMAS" end)
      |> Enum.count()

    IO.inspect(part1)
  end
end
