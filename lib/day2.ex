# https://adventofcode.com/2016/day/2
defmodule Day2 do
  def parse_line(line) do
    String.split(line) |> Enum.map(&String.to_integer/1)
  end

  def is_increasing(line) do
    Enum.sort(line) == line
  end

  def is_decreasing(line) do
    Enum.sort(line) |> Enum.reverse() == line
  end

  def is_gradual(line) do
    Enum.zip(line, Enum.drop(line, 1))
    |> Enum.all?(fn {a, b} -> abs(b - a) >= 1 and abs(b - a) <= 3 end)
  end

  def is_valid(line) do
    (is_increasing(line) or is_decreasing(line)) and is_gradual(line)
  end

  def drop_n(xs, n) do
    Enum.zip(xs, 0..Enum.count(xs))
    |> Enum.filter(fn {_x, i} -> i != n end)
    |> Enum.map(fn {x, _i} -> x end)
  end

  def valid2(xs) do
    is_valid(xs) || Enum.any?(0..Enum.count(xs), fn n -> is_valid(drop_n(xs, n)) end)
  end

  def main(input_file) do
    instrs = Util.read_lines(input_file) |> Enum.map(&parse_line/1)

    IO.inspect(instrs)

    valids = Enum.filter(instrs, &is_valid/1)

    IO.inspect(valids)
    IO.puts(Enum.count(valids))

    valids2 = Enum.filter(instrs, &valid2/1)
    IO.inspect(valids2)
    IO.puts(Enum.count(valids2))
  end
end
