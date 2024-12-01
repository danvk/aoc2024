defmodule Day4 do
  def count_letters(str) do
    str
    |> String.to_charlist()
    |> Enum.filter(&(&1 >= ?a and &1 <= ?z))
    |> Enum.group_by(& &1)
    |> Enum.map(fn {k, v} -> {k, Enum.count(v)} end)
    |> Enum.sort(fn {k1, c1}, {k2, c2} -> c1 > c2 or (c1 == c2 and k1 < k2) end)
  end

  def parse_line(line) do
    [room, checksum] = String.split(line, ["[", "]"], trim: true)
    {room, checksum}
  end

  @spec counts_to_checksum(any()) :: binary()
  def counts_to_checksum(checksum) do
    Enum.take(checksum, 5)
    |> Enum.map(fn {k, _} -> k end)
    |> List.to_string()
  end

  @spec main(nonempty_maybe_improper_list()) :: 0
  def main(args) do
    input_file = hd(args)
    instrs = Util.read_lines(input_file) |> Enum.map(&parse_line/1)
    IO.inspect(instrs)

    counts =
      Enum.map(instrs, fn {room, chk} -> {counts_to_checksum(count_letters(room)), chk} end)

    IO.inspect(instrs |> Enum.at(2) |> elem(0))
    IO.inspect(count_letters(instrs |> Enum.at(2) |> elem(0)))

    valids = Enum.filter(counts, fn {chk, chk2} -> chk == chk2 end)
    IO.puts(valids |> Enum.count())
    IO.inspect(counts)
  end
end
