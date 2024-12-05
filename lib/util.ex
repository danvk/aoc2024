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

  def enumerate(xs) do
    Enum.zip(0..Enum.count(xs), xs)
  end

  # Read a file into an {x, y} -> char Map.
  # Returns the grid and its max x & y coordinates
  def read_grid(input_file) do
    grid =
      for {y, line} <- Util.read_lines(input_file) |> Util.enumerate(),
          {x, char} <- line |> String.to_charlist() |> Util.enumerate(),
          into: %{},
          do: {{x, y}, char}

    w = for({x, _y} <- Map.keys(grid), do: x) |> Enum.max()
    h = for({_x, y} <- Map.keys(grid), do: y) |> Enum.max()

    {grid, {w, h}}
  end

  def pos_str(pos) do
    "#{elem(pos, 0)},#{elem(pos, 1)}"
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
end
