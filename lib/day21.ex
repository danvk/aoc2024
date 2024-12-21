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
    for c <- chars, reduce: start do
      {x, y} ->
        {dx, dy} = @dirs[c]
        {x + dx, y + dy}
    end
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
    # IO.inspect({[xc], nx, [yc], ny})
    all_seqs(xc, nx, yc, ny) |> Enum.filter(&valid_sequence({x1, y1}, &1))
    # todo: filter to just sequences that stay on the keypad
  end

  def main(input_file) do
    # instrs = Util.read_lines(input_file) |> Enum.map(&String.to_charlist/1)
    # Util.inspect(instrs)

    IO.inspect(numpad_sequences(?A, ?2))
    IO.inspect(numpad_sequences(?A, ?7))
  end
end
