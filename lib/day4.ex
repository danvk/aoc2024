# https://adventofcode.com/2024/day/4
defmodule Day4 do
  def parse_line(line) do
    String.split(line)
  end

  def main(input_file) do
    grid =
      for {i, line} <- Util.read_lines(input_file) |> Util.enumerate(),
          {j, char} <- line |> String.to_charlist() |> Util.enumerate(),
          into: %{},
          do: {{i, j}, char}

    IO.inspect(grid)
  end
end
