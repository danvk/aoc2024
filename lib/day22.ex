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

  defp index_quad(quads) do
    for {bananas, quad} <- quads, reduce: %{} do
      acc ->
        Util.get_and_update(acc, quad, fn old -> if old == nil, do: bananas, else: old end)
    end
  end

  def main(input_file) do
    seeds = Util.read_lines(input_file) |> Enum.map(&String.to_integer/1)
    after2000 = Enum.map(seeds, &secret_after(&1, 2000))
    part1 = after2000 |> Enum.sum()
    IO.puts("part 1: #{part1}")

    seqs = for seed <- seeds, do: steps(seed, 2001)

    quads =
      for {bananas, deltas} <- seqs,
          do: Enum.zip(Enum.drop(bananas, 3), sliding_window(deltas, 4))

    indexed = quads |> Enum.map(&index_quad/1)

    part2 =
      for q <- indexed, reduce: %{} do
        m -> Map.merge(m, q, fn _, v1, v2 -> v1 + v2 end)
      end
      |> Map.values()
      |> Enum.max()

    IO.puts("part 2: #{part2}")
  end
end
