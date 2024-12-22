# https://adventofcode.com/2024/day/22
defmodule Day22 do
  defp mix(a, b), do: Bitwise.bxor(a, b)
  defp prune(a), do: rem(a, 16_777_216)

  defp step(secret) do
    secret = secret |> mix(64 * secret) |> prune()
    secret = secret |> mix(div(secret, 32)) |> prune()
    secret = secret |> mix(2048 * secret) |> prune()
    secret
  end

  defp secret_after(init, 0), do: init
  defp secret_after(init, n), do: step(secret_after(init, n - 1))

  defp secrets(init, n) do
    1..n |> Enum.scan(init, fn _, secret -> step(secret) end)
  end

  defp steps(init, n) do
    seq = secrets(init, n - 1)

    {
      for(b <- seq, do: rem(b, 10)),
      Enum.zip([init | seq], seq)
      |> Enum.map(fn {a, b} -> rem(b, 10) - rem(a, 10) end)
    }
  end

  defp sliding_window(seq, 1), do: for(x <- seq, do: [x])

  defp sliding_window(seq, n) do
    for {head, tail} <- Enum.zip(seq, sliding_window(tl(seq), n - 1)), do: [head | tail]
  end

  # defp buy_bananas(quads, seq) do
  #   {bananas, _} = Enum.find(quads, {0, nil}, fn {_, q} -> q == seq end)
  #   bananas
  # end

  defp index_quad(quads) do
    for {bananas, quad} <- quads, reduce: %{} do
      acc ->
        Util.get_and_update(acc, quad, fn old -> if old == nil, do: bananas, else: old end)
    end
  end

  def main(input_file) do
    seeds = Util.read_lines(input_file) |> Enum.map(&String.to_integer/1)
    # Util.inspect(instrs)
    after2000 = Enum.map(seeds, &secret_after(&1, 2000))
    # Util.inspect(instrs |> Enum.zip(after2000))
    part1 = after2000 |> Enum.sum()
    IO.puts("part 1: #{part1}")

    seqs = for seed <- seeds, do: steps(seed, 2001)
    # Util.inspect(seqs)

    quads =
      for {bananas, deltas} <- seqs,
          do: Enum.zip(Enum.drop(bananas, 3), sliding_window(deltas, 4))

    indexed = quads |> Enum.map(&index_quad/1)

    # Util.inspect(indexed)

    # Util.inspect(for quad <- quads, do: buy_bananas(quad, [-2, 1, -1, 3]))

    part2 =
      Enum.max(
        for a <- -9..9,
            b <- -9..9,
            c <- -9..9,
            d <- -9..9,
            do: Enum.sum(for q <- indexed, do: Map.get(q, [a, b, c, d], 0))
      )

    # Util.inspect(for q <- indexed, do: q[[-2, 1, -1, 3]])

    IO.puts("part 2: #{part2}")

    # Util.inspect(quads)

    # Util.inspect(sliding_window(Enum.to_list(1..10), 4))

    # Util.inspect(mix(42, 15))
    # Util.inspect(prune(100_000_000))
    # for _ <- 1..10, reduce: 123 do
    #   secret ->
    #     secret = step(secret)
    #     Util.inspect(secret)
    #     secret
    # end
  end
end
