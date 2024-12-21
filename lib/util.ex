defmodule Util do
  def accumulate(xs, f, acc) do
    {_, seq} =
      Enum.reduce(xs, {acc, []}, fn x, {acc, accs} ->
        new_acc = f.(x, acc)
        {new_acc, [new_acc | accs]}
      end)

    Enum.reverse(seq)
  end

  def read_lines(file) do
    File.read!(file) |> String.trim_trailing() |> String.split("\n")
  end

  # Split a list of lines on the first blank line, returning a tuple.
  def split_on_blank(lines) do
    {a, ["" | b]} = lines |> Enum.split_while(&(&1 != ""))
    {a, b}
  end

  def split_on(enumerable, value) do
    enumerable |> Enum.chunk_by(&(&1 == value)) |> Enum.filter(&(&1 != [value]))
  end

  def enumerate(xs) do
    Enum.zip(0..Enum.count(xs), xs)
  end

  # Read a file into an {x, y} -> char Map.
  # Returns the grid and its max x & y coordinates
  def read_grid(input_file) do
    Util.read_lines(input_file) |> read_grid_from_lines()
  end

  def read_grid_from_lines(lines) do
    grid =
      for {y, line} <- lines |> Util.enumerate(),
          {x, char} <- line |> String.to_charlist() |> Util.enumerate(),
          into: %{},
          do: {{x, y}, char}

    w = for({x, _y} <- Map.keys(grid), do: x) |> Enum.max()
    h = for({_x, y} <- Map.keys(grid), do: y) |> Enum.max()

    {grid, {w, h}}
  end

  def print_grid(grid, {w, h}) do
    for y <- 0..h do
      for x <- 0..w do
        IO.write([Map.get(grid, {x, y}, ?.)])
      end

      IO.puts("")
    end
  end

  def find_and_replace_char_in_grid(grid, target, replacement) do
    for(
      {p, v} <- grid,
      do:
        if(v == target) do
          {Map.put(grid, p, replacement), p}
        else
          nil
        end
    )
    |> Enum.filter(& &1)
    |> hd()
  end

  def pairs(xs) do
    for {x, i} <- Enum.with_index(xs), y <- Enum.drop(xs, i), do: {x, y}
  end

  def first({a, _b}) do
    a
  end

  def first([a, _b]) do
    a
  end

  def second({_a, b}) do
    b
  end

  def second([_a, b]) do
    b
  end

  def inspect(x) do
    IO.inspect(x, charlists: false)
  end

  def inspect(a, b) do
    IO.inspect({a, b}, charlists: false)
  end

  def read_ints(txt, delim) do
    txt |> String.split(delim) |> Enum.map(&String.to_integer/1)
  end

  def extract_ints(txt) do
    txt
    |> String.to_charlist()
    |> Enum.chunk_by(fn x -> x >= ?0 && x <= ?9 end)
    |> Enum.filter(fn part -> hd(part) >= ?0 && hd(part) <= ?9 end)
    |> Enum.map(fn part -> String.to_integer("#{part}") end)
  end

  # Like Map.get_and_update, but with a more sane type signature.
  def get_and_update(m, k, f) do
    {_, new_m} = Map.get_and_update(m, k, fn v -> {v, f.(v)} end)
    new_m
  end

  # TODO: most uses of this don't care about the key
  def map_values(m, f) do
    Map.new(m, fn {k, v} -> {k, f.(k, v)} end)
  end

  def invert_map(m) do
    for {k, v} <- m, into: %{}, do: {v, k}
  end

  def count_by(enum, f) do
    enum |> Enum.group_by(f) |> Util.map_values(fn _k, v -> Enum.count(v) end)
  end

  def move({x, y}, dir, d \\ 1) do
    case dir do
      :E -> {x + d, y}
      :W -> {x - d, y}
      :N -> {x, y - d}
      :S -> {x, y + d}
    end
  end

  def turn(dir, turn) do
    case {dir, turn} do
      {:E, :R} -> :S
      {:E, :L} -> :N
      {:W, :R} -> :N
      {:W, :L} -> :S
      {:N, :R} -> :E
      {:N, :L} -> :W
      {:S, :R} -> :W
      {:S, :L} -> :E
    end
  end

  def l1_dist({x1, y1}, {x2, y2}), do: abs(x2 - x1) + abs(y2 - y1)
end
