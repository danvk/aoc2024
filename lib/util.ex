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

  def enumerate(xs) do
    Enum.zip(0..Enum.count(xs), xs)
  end

  def pos_str(pos) do
    "#{elem(pos, 0)},#{elem(pos, 1)}"
  end
end
