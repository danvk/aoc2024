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

  def expand2(xs, acc \\ %{}, pos \\ 0, i \\ 0) do
    case xs do
      [used | [free | rest]] ->
        expand2(
          rest,
          acc |> Map.put(pos..(pos + used), i) |> Map.put((pos + used)..(pos + used + free), nil),
          pos + used + free,
          i + 1
        )

      [used] ->
        Map.put(acc, pos..(pos + used), i)

      [] ->
        acc
    end
  end

  def checksum(xs) do
    Enum.with_index(xs) |> Enum.map(fn {x, i} -> x * i end) |> Enum.sum()
  end

  def find_gap(m, size) do
    candidates =
      m
      |> Map.to_list()
      |> Enum.filter(fn {a..b//1, v} -> v == nil && b - a >= size end)

    case candidates do
      [] ->
        nil

      _ ->
        candidates |> Enum.min_by(fn {k, _v} -> k end)
    end
  end

  def key_for(m, v) do
    x = for {k, val} <- m, v == val, do: k
    x |> Enum.at(0)
  end

  def shift2(m, -1) do
    m
  end

  def shift2(n, m) do
    # Util.inspect(m, n)
    k = key_for(m, n)
    # Util.inspect(k)
    a..b//_ = k

    cond do
      a == b ->
        m

      true ->
        gap = find_gap(m, b - a)
        # Util.inspect(gap)

        case gap do
          nil ->
            m

          {ga..gb//_, nil} ->
            m
            |> Map.drop([k, ga..gb])
            |> Map.put(ga..(ga + b - a), n)
            # todo: this might be empty
            |> Map.put((ga + b - a)..gb, nil)
        end
    end
  end

  def part2(m, maxv) do
    maxv..0 |> Enum.reduce(m, &shift2/2)
  end

  def range_sum(a..b//1) do
    cond do
      b <= a -> 0
      true -> a..(b - 1) |> Enum.sum()
    end
  end

  def checksum2(m) do
    m
    |> Enum.filter(fn {a..b//1, v} -> v != nil && b > a end)
    |> Enum.map(fn {r, v} -> v * range_sum(r) end)
    |> Enum.sum()
  end

  def main(input_file) do
    input =
      File.read!(input_file)
      |> String.trim_trailing()
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)

    Util.inspect(repeat(nil, 0))

    Util.inspect(range_sum(1..1))
    Util.inspect(range_sum(1..2))
    Util.inspect(range_sum(5..7))

    disk = expand(input)
    # Util.inspect(disk)
    # Util.inspect(disk |> Enum.count())
    # IO.inspect(disk, charlists: false, limit: 1_000_000)
    # Util.inspect(part1(disk))
    compacted = part1(disk)
    # Util.inspect(compacted)
    # Util.inspect(compacted |> Enum.count())
    # Util.inspect(disk |> Enum.max())
    # Util.inspect(compacted |> Enum.max())
    p1 = checksum(compacted)
    IO.puts("part 1: #{p1}")

    n = compacted |> Enum.max()
    m2 = expand2(input)
    # Util.inspect(m2)
    # Util.inspect(shift2(m2, n))
    p2 = part2(m2, n)
    Util.inspect(checksum2(p2))
  end
end
