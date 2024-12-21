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
  @pos_to_num Util.invert_map(@numpad)

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

  @pos_to_dir Util.invert_map(@dirpad)

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

    all_seqs(xc, nx, yc, ny)
    |> Enum.filter(&valid_dirpad_sequence({x1, y1}, &1))
  end

  def dirpad_sequences(_, []), do: [[]]

  def dirpad_sequences(start, [next | rest]) do
    seqs = dirpad_sequence(start, next)
    rest_seqs = dirpad_sequences(next, rest)

    [
      for(a <- seqs, b <- rest_seqs, do: a ++ ~c"A" ++ b)
      |> Enum.min_by(&dirpad_cost/1)
    ]
  end

  # Rough cost of tracing out this sequence on the direction pad
  def dirpad_cost(seq) do
    Enum.zip([?A | seq], seq)
    |> Enum.map(fn {a, b} ->
      Util.l1_dist(@dirpad[a], @dirpad[b])
    end)
    |> Enum.sum()
  end

  def pick_shortest(seqs) do
    shortest = Enum.min(seqs |> Enum.map(&(&1 |> Enum.count())))
    seqs |> Enum.find(&(Enum.count(&1) == shortest))
  end

  def all_shortest(seqs) do
    shortest = Enum.min(seqs |> Enum.map(&(&1 |> Enum.count())))
    seqs |> Enum.filter(&(Enum.count(&1) == shortest))
  end

  def dir_for_dir(dirkeys) do
    # IO.inspect(dirkeys)
    seqs = dirpad_sequences(?A, dirkeys)
    Util.inspect("dfd seqs", seqs |> Enum.count())
    seqs |> Enum.min_by(&dirpad_cost/1)
    # all_shortest(seqs)
  end

  def cost1(num_seq) do
    seqs = keypad_sequences(?A, num_seq)
    dir_seqs = seqs |> Enum.flat_map(&dir_for_dir/1)
    all_shortest(dir_seqs)
  end

  def cost2(num_seq) do
    seqs = cost1(num_seq)
    dir_seqs = seqs |> Enum.flat_map(&dir_for_dir/1)
    pick_shortest(dir_seqs) |> Enum.count()
  end

  def cost_n(num_seq, n) do
    # |> Enum.count()
    # |> pick_shortest()
    # cost_n_help(num_seq, n) |> pick_shortest()
    # cost_n_help(num_seq, n - 1)
    # |> Enum.map(fn seq -> dir_for_dir(seq) |> pick_shortest() end)
    # |> pick_shortest()
    # |> Enum.count()
    cost_n_help(num_seq, n) |> pick_shortest() |> Enum.count()
  end

  def cost_n_help(num_seq, 0) do
    keypad_sequences(?A, num_seq) |> all_shortest()
  end

  def cost_n_help(num_seq, n) do
    seqs = cost_n_help(num_seq, n - 1)

    r =
      seqs
      |> Enum.map(fn seq -> dir_for_dir(seq) end)
      |> Enum.min_by(&dirpad_cost/1)

    IO.puts("n=#{n}, seq_len=#{r |> Enum.count()}")
    [r]
    # seqs |> Enum.map(fn seq -> dir_for_dir(seq) |> pick_shortest() end)
  end

  def complexity({numseq, cost}) do
    [numpart] = Util.extract_ints(numseq)
    numpart * cost
  end

  def dir_to_dir(dirseq) do
    dirseq
    |> Enum.reduce({@dirpad[?A], []}, fn c, {p, out} ->
      if c == ?A do
        {p, out ++ [@pos_to_dir[p]]}
      else
        {x, y} = p
        {dx, dy} = @dirs[c]
        {{x + dx, y + dy}, out}
      end
    end)
    |> elem(1)
  end

  def dir_to_num(dirseq) do
    dirseq
    |> Enum.reduce({@numpad[?A], []}, fn c, {p, out} ->
      if c == ?A do
        {p, out ++ [@pos_to_num[p]]}
      else
        {x, y} = p
        {dx, dy} = @dirs[c]
        {{x + dx, y + dy}, out}
      end
    end)
    |> elem(1)
  end

  def build_cost_table(0) do
    for a <- ~c"^<v>A",
        b <- ~c"^<v>A",
        into: %{},
        do: {{a, b}, Util.l1_dist(@dirpad[a], @dirpad[b])}
  end

  # does there need to be a +1 in here somewhere?
  def build_cost_table(n) do
    cost_table = build_cost_table(n - 1)

    for a <- ~c"^<v>A", b <- ~c"^<v>A", into: %{} do
      seqs = dirpad_sequence(a, b)

      cost =
        seqs
        |> Enum.map(fn
          [] ->
            0

          seq ->
            Enum.zip(seq, seq |> tl())
            |> Enum.map(fn {a, b} -> cost_table[{a, b}] end)
            |> Enum.sum()
        end)
        |> Enum.min()

      {{a, b}, cost + 1}
    end
  end

  def cost_for_numpad_seq(num_seq, cost_table) do
    keypad_sequences(?A, num_seq)
    |> Enum.map(fn seq ->
      Enum.zip(seq, seq |> tl())
      |> Enum.map(fn {a, b} -> 1 + cost_table[{a, b}] end)
      |> Enum.sum()
    end)
    |> Enum.min()
  end

  def format_table(cost_table) do
    for {{a, b}, c} <- cost_table, into: %{}, do: {[a, b], c}
  end

  def main(input_file) do
    numpad_seqs = Util.read_lines(input_file) |> Enum.map(&String.to_charlist/1)
    # Util.inspect(instrs)

    # IO.inspect(numpad_sequences(?A, ?2))
    # IO.inspect(numpad_sequences(?A, ?7))
    # IO.inspect(numpad_sequences(?0, ?1))
    IO.inspect(format_table(build_cost_table(0)))
    table2 = build_cost_table(2)

    results =
      numpad_seqs
      |> Enum.map(fn seq -> {"#{seq}", cost_for_numpad_seq(seq, table2)} end)

    # npseq = numpad_seqs |> hd()
    # path = cost_n(npseq, 2)
    # IO.inspect(path)
    # IO.inspect(dir_to_dir(path))
    # IO.inspect(dir_to_dir(dir_to_dir(path)))
    # IO.inspect(dir_to_num(dir_to_dir(dir_to_dir(path))))

    Util.inspect(results)
    Util.inspect(results |> Enum.map(&complexity/1) |> Enum.sum())

    # IO.inspect(dirpad_cost(~c"v<<A>>^A<A>AvA<^AA>A<vAAA>^A"))
    # IO.inspect(dirpad_cost(~c"<v<A>>^A<A>AvA<^AA>A<vAAA>^A"))

    # results25 =
    #   numpad_seqs
    #   |> Enum.map(fn seq -> {"#{seq}", cost_n(seq, 25)} end)
    # Util.inspect(results25)
    # Util.inspect(results25 |> Enum.map(&complexity/1) |> Enum.sum())
  end
end
