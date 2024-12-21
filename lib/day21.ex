# https://adventofcode.com/2024/day/21
defmodule Day21 do
  @numpad %{
    ?7 => {0, 0},
    ?8 => {1, 0},
    ?9 => {2, 0},
    ?4 => {0, 1},
    ?5 => {1, 1},
    ?6 => {2, 1},
    ?1 => {0, 2},
    ?2 => {1, 2},
    ?3 => {2, 2},
    ?0 => {1, 3},
    ?A => {2, 3}
  }

  @dirs %{
    ?> => {1, 0},
    ?< => {-1, 0},
    ?^ => {0, -1},
    ?v => {0, 1}
  }

  defp valid_numpad({x, y}) do
    x >= 0 and x <= 3 and y >= 0 and (y <= 2 or (y == 3 && x >= 1))
  end

  defp valid_sequence(start, chars) do
    chars
    |> Enum.scan(start, fn c, {x, y} ->
      {dx, dy} = @dirs[c]
      {x + dx, y + dy}
    end)
    |> Enum.all?(&valid_numpad/1)
  end

  defp all_seqs(_c1, 0, _c2, 0), do: [[]]

  defp all_seqs(c1, n1, c2, n2) do
    pick1 = if n1 > 0, do: for(rest <- all_seqs(c1, n1 - 1, c2, n2), do: [c1 | rest]), else: []
    pick2 = if n2 > 0, do: for(rest <- all_seqs(c1, n1, c2, n2 - 1), do: [c2 | rest]), else: []
    pick1 ++ pick2
  end

  defp numpad_sequences(start, stop) do
    {x1, y1} = @numpad[start]
    {x2, y2} = @numpad[stop]
    dx = x2 - x1
    dy = y2 - y1
    xc = if dx <= 0, do: ?<, else: ?>
    yc = if dy <= 0, do: ?^, else: ?v
    nx = abs(dx)
    ny = abs(dy)
    all_seqs(xc, nx, yc, ny) |> Enum.filter(&valid_sequence({x1, y1}, &1))
  end

  defp keypad_sequences(_, []), do: [[]]

  defp keypad_sequences(start, [next | rest]) do
    seqs = numpad_sequences(start, next)
    rest_seqs = keypad_sequences(next, rest)
    for a <- seqs, b <- rest_seqs, do: a ++ ~c"A" ++ b
  end

  @dirpad %{
    ?^ => {1, 0},
    ?A => {2, 0},
    ?< => {0, 1},
    ?v => {1, 1},
    ?> => {2, 1}
  }

  defp valid_dirpad({x, y}) do
    x >= 0 and x <= 2 and (y == 1 or (y == 0 and x >= 1))
  end

  defp valid_dirpad_sequence(start, chars) do
    chars
    |> Enum.scan(start, fn c, {x, y} ->
      {dx, dy} = @dirs[c]
      {x + dx, y + dy}
    end)
    |> Enum.all?(&valid_dirpad/1)
  end

  defp dirpad_sequence(start, stop) do
    {x1, y1} = @dirpad[start]
    {x2, y2} = @dirpad[stop]
    dx = x2 - x1
    dy = y2 - y1
    xc = if dx <= 0, do: ?<, else: ?>
    yc = if dy <= 0, do: ?^, else: ?v
    nx = abs(dx)
    ny = abs(dy)

    all_seqs(xc, nx, yc, ny)
    |> Enum.filter(&valid_dirpad_sequence({x1, y1}, &1))
  end

  defp complexity({numseq, cost}) do
    [numpart] = Util.extract_ints(numseq)
    numpart * cost
  end

  defp build_cost_table(0) do
    for a <- ~c"^<v>A",
        b <- ~c"^<v>A",
        into: %{},
        do: {{a, b}, 1}
  end

  defp build_cost_table(n) do
    cost_table = build_cost_table(n - 1)

    for a <- ~c"^<v>A", b <- ~c"^<v>A", into: %{} do
      seqs = for seq <- dirpad_sequence(a, b), do: seq ++ [?A]

      cost =
        seqs
        |> Enum.map(fn
          seq ->
            Enum.zip([?A | seq], seq)
            |> Enum.map(fn {a, b} -> cost_table[{a, b}] end)
            |> Enum.sum()
        end)
        |> Enum.min()

      {{a, b}, cost}
    end
  end

  defp cost_for_numpad_seq(num_seq, cost_table) do
    keypad_sequences(?A, num_seq)
    |> Enum.map(fn seq ->
      Enum.zip([?A | seq], seq)
      |> Enum.map(fn {a, b} -> cost_table[{a, b}] end)
      |> Enum.sum()
    end)
    |> Enum.min()
  end

  def main(input_file) do
    numpad_seqs = Util.read_lines(input_file) |> Enum.map(&String.to_charlist/1)
    table2 = build_cost_table(2)

    results =
      numpad_seqs
      |> Enum.map(fn seq -> {"#{seq}", cost_for_numpad_seq(seq, table2)} end)

    Util.inspect(results)
    part1 = results |> Enum.map(&complexity/1) |> Enum.sum()
    IO.puts("Part 1: #{part1}")

    table25 = build_cost_table(25)

    results =
      numpad_seqs
      |> Enum.map(fn seq -> {"#{seq}", cost_for_numpad_seq(seq, table25)} end)

    Util.inspect(results)
    part2 = results |> Enum.map(&complexity/1) |> Enum.sum()
    IO.puts("Part 2: #{part2}")
  end
end
