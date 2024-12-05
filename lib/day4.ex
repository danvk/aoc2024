# https://adventofcode.com/2024/day/4
defmodule Day4 do
  def chars_in_dir(grid, n, {x, y}, {dx, dy}) do
    Enum.map(0..(n - 1), fn i -> grid[{x + i * dx, y + i * dy}] end)
  end

  def main(input_file) do
    {grid, {w, h}} = Util.read_grid(input_file)

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

    part1 =
      for(
        x <- 0..w,
        y <- 0..h,
        dir <- dirs,
        do: {{x, y}, dir, chars_in_dir(grid, 4, {x, y}, dir)}
      )
      |> Enum.filter(fn {_, _, chars} -> chars == ~c"XMAS" end)
      |> Enum.count()

    IO.inspect(part1)

    part2 =
      for(
        x <- 0..w,
        y <- 0..h,
        do:
          {{x, y}, chars_in_dir(grid, 3, {x - 1, y - 1}, {1, 1}),
           chars_in_dir(grid, 3, {x - 1, y + 1}, {1, -1})}
      )
      |> Enum.filter(fn {_, c1, c2} ->
        (c1 == ~c"MAS" || c1 == ~c"SAM") && (c2 == ~c"MAS" || c2 == ~c"SAM")
      end)

    # IO.inspect(part2)
    IO.puts(part2 |> Enum.count())
  end
end
