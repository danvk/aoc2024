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

  def valid_numpad({x, y}) do
    x >= 0 and x <= 3 and y >= 0 and (y <= 2 or (y == 3 && x >= 1))
  end

  def valid_sequence(start, chars) do
    chars
    |> Enum.scan(start, fn c, {x, y} ->
      {dx, dy} = @dirs[c]
      {x + dx, y + dy}
    end)
    |> Enum.all?(&valid_numpad/1)
  end

  def all_seqs(_c1, 0, _c2, 0), do: [[]]

  def all_seqs(c1, n1, c2, n2) do
    pick1 = if n1 > 0, do: for(rest <- all_seqs(c1, n1 - 1, c2, n2), do: [c1 | rest]), else: []
    pick2 = if n2 > 0, do: for(rest <- all_seqs(c1, n1, c2, n2 - 1), do: [c2 | rest]), else: []
    pick1 ++ pick2
  end

  def numpad_sequences(start, stop) do
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

  def keypad_sequences(_, []), do: [[]]

  def keypad_sequences(start, [next | rest]) do
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

  def valid_dirpad({x, y}) do
    x >= 0 and x <= 2 and (y == 1 or (y == 0 and x >= 1))
  end

  def valid_dirpad_sequence(start, chars) do
    chars
    |> Enum.scan(start, fn c, {x, y} ->
      {dx, dy} = @dirs[c]
      {x + dx, y + dy}
    end)
    |> Enum.all?(&valid_dirpad/1)
  end

  def dirpad_sequence(start, stop) do
    {x1, y1} = @dirpad[start]
    {x2, y2} = @dirpad[stop]
    dx = x2 - x1
    dy = y2 - y1
    xc = if dx <= 0, do: ?<, else: ?>
    yc = if dy <= 0, do: ?^, else: ?v
    nx = abs(dx)
    ny = abs(dy)
    all_seqs(xc, nx, yc, ny) |> Enum.filter(&valid_dirpad_sequence({x1, y1}, &1))
  end

  def dirpad_sequences(_, []), do: [[]]

  def dirpad_sequences(start, [next | rest]) do
    seqs = dirpad_sequence(start, next)
    rest_seqs = dirpad_sequences(next, rest)
    for a <- seqs, b <- rest_seqs, do: a ++ ~c"A" ++ b
  end

  def dir_for_dir(dirkeys) do
    IO.inspect(dirkeys)
    seqs = dirpad_sequences(?A, dirkeys)
    # TODO: is this filter actually necessary?
    shortest = Enum.min(seqs |> Enum.map(&(&1 |> Enum.count())))
    seqs |> Enum.filter(&(Enum.count(&1) == shortest))
  end

  def cost1(num_seq) do
    seqs = keypad_sequences(?A, num_seq)
    dir_seqs = seqs |> Enum.flat_map(&dir_for_dir/1)
    IO.inspect(dir_seqs)
    Enum.min(dir_seqs |> Enum.map(&(&1 |> Enum.count())))
  end

  def main(input_file) do
    numpad_seqs = Util.read_lines(input_file) |> Enum.map(&String.to_charlist/1)
    # Util.inspect(instrs)

    # IO.inspect(numpad_sequences(?A, ?2))
    # IO.inspect(numpad_sequences(?A, ?7))
    # IO.inspect(numpad_sequences(?0, ?1))
    Util.inspect(
      numpad_seqs
      |> Enum.map(fn seq -> {"#{seq}", cost1(seq)} end)
    )
  end
end
