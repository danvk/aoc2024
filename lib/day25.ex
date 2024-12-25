# https://adventofcode.com/2024/day/25
defmodule Day25 do
  def transpose(matrix) do
    width = matrix |> hd() |> String.length()
    height = matrix |> Enum.count()

    for x <- 0..(width - 1) do
      for y <- 0..(height - 1) do
        String.at(Enum.at(matrix, y), x)
      end
    end
  end

  defp parse_nums(lines) do
    lines |> Enum.map(&(Enum.count(&1, fn x -> x == "#" end) - 1))
  end

  defp parse_key_lock(lines) do
    trans = transpose(lines)

    sym =
      case trans do
        [["#" | _] | _] -> :lock
        [["." | _] | _] -> :key
      end

    {sym, parse_nums(trans)}
  end

  defp fits(key, lock) do
    for({a, b} <- Enum.zip(key, lock), do: a + b <= 5)
    |> Enum.all?()
  end

  def main(input_file) do
    keys_locks =
      Util.read_lines(input_file) |> Util.split_on_blanks() |> Enum.map(&parse_key_lock/1)

    Util.inspect(keys_locks)

    grouped = keys_locks |> Enum.group_by(&Util.first/1)
    keys = grouped.key |> Enum.map(&Util.second/1)
    locks = grouped.lock |> Enum.map(&Util.second/1)

    # Util.inspect(keys |> Enum.count(), locks |> Enum.count())
    for(
      key <- keys,
      lock <- locks,
      do: fits(key, lock)
    )
    |> Enum.count(& &1)
    |> IO.puts()

    # Util.inspect(keys_locks |> hd() |> transpose())
  end
end
