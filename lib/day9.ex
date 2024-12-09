# https://adventofcode.com/2024/day/9
defmodule Day9 do
  # def first_free(xs, start_idx \\ 0) do
  #   # Enum.find_index(xs, &is_nil/1, start_idx)
  # end

  def part1(xs) do
    n = Enum.filter(xs, &(&1 != nil)) |> Enum.count()
    result = shift(xs, Enum.reverse(xs))
    Enum.take(result, n)
  end

  def shift(xs, rev_xs) do
    # Util.inspect(xs, rev_xs)

    case {xs, rev_xs} do
      {_, [nil | rest]} ->
        shift(xs, rest)

      {[nil | rest], [v | restr]} ->
        [v | shift(rest, restr)]

      {[v | rest], _} ->
        [v | shift(rest, rev_xs)]

      {[], _} ->
        []

      {_, []} ->
        xs
    end
  end

  def repeat(_, 0) do
    []
  end

  def repeat(x, n) do
    for _ <- 1..n, do: x
  end

  def expand(xs, i \\ 0) do
    case xs do
      [used | [free | rest]] ->
        [repeat(i, used) | [repeat(nil, free) | expand(rest, i + 1)]] |> List.flatten()

      [used] ->
        [repeat(i, used)]

      [] ->
        []
    end
  end

  def checksum(xs) do
    Enum.with_index(xs) |> Enum.map(fn {x, i} -> x * i end) |> Enum.sum()
  end

  def main(input_file) do
    disk =
      File.read!(input_file)
      |> String.trim_trailing()
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)

    Util.inspect(repeat(nil, 0))

    # Util.inspect(disk)
    disk = expand(disk)
    # Util.inspect(disk |> Enum.count())
    # IO.inspect(disk, charlists: false, limit: 1_000_000)
    # Util.inspect(part1(disk))
    compacted = part1(disk)
    # Util.inspect(compacted)
    Util.inspect(compacted |> Enum.count())
    Util.inspect(disk |> Enum.max())
    Util.inspect(compacted |> Enum.max())
    p1 = checksum(compacted)
    IO.puts("part 1: #{p1}")
  end
end
