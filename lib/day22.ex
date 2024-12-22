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

  def main(input_file) do
    instrs = Util.read_lines(input_file) |> Enum.map(&String.to_integer/1)
    # Util.inspect(instrs)
    after2000 = Enum.map(instrs, &secret_after(&1, 2000))
    # Util.inspect(instrs |> Enum.zip(after2000))
    part1 = after2000 |> Enum.sum()
    IO.puts("part 1: #{part1}")

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
