defmodule Day3 do
  def part1 do
    IO.puts("part1")
  end

  def part2 do
    IO.puts("part2")
  end

  def is_valid([a, b, c]) do
    a + b > c and a + c > b and b + c > a
  end

  def transpose(ary) do
    for i <- 0..2, do: for(j <- 0..2, do: Enum.at(Enum.at(ary, j), i))
  end

  def main(args) do
    input_file = hd(args)

    instrs =
      Util.read_lines(input_file)
      |> Enum.map(&String.split/1)
      |> Enum.map(&Enum.map(&1, fn s -> String.to_integer(s) end))

    part1valid = instrs |> Enum.filter(&Day3.is_valid/1)
    # IO.inspect(instrs)
    IO.puts(part1valid |> Enum.count())

    # IO.inspect(instrs)
    # first3 = instrs |> Enum.take(3)
    # IO.inspect(first3)
    # first3tr = first3 |> Day3.transpose()
    # IO.inspect(first3tr)

    instrs2 =
      Enum.chunk_every(instrs, 3)
      |> Enum.map(&Day3.transpose/1)
      |> Enum.flat_map(& &1)

    part2valid = instrs2 |> Enum.filter(&Day3.is_valid/1)
    IO.puts(part2valid |> Enum.count())

    # IO.inspect(instrs2)
  end
end
