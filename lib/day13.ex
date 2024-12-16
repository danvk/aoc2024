# https://adventofcode.com/2024/day/13
defmodule Day13 do
  def maybe_solution(n_a, machine) do
    {{ax, ay}, {bx, by}, {px, py}} = machine
    dx = px - n_a * ax
    dy = py - n_a * ay

    cond do
      dx < 0 ->
        nil

      dy < 0 ->
        nil

      rem(dx, bx) != 0 ->
        nil

      rem(dy, by) != 0 ->
        nil

      true ->
        n_bx = Integer.floor_div(dx, bx)
        n_by = Integer.floor_div(dy, by)

        if n_bx == n_by do
          n_bx
        else
          nil
        end
    end
  end

  def solve1(machine) do
    for n_a <- 0..100 do
      {n_a, maybe_solution(n_a, machine)}
    end
    |> Enum.filter(&(elem(&1, 1) != nil))
    |> Enum.filter(fn {_a, b} -> b <= 100 end)
    |> Enum.map(fn {a, b} -> 3 * a + b end)
    |> Enum.min(&<=/2, fn -> 0 end)
  end

  def parse_line(lines) do
    # case lines do
    #   ["Button A: X+#{ax}, Y+#{ay}", "Button B: X+#{bx}, Y+#{by}", "Prize: X=#{px}, Y=#{py}"] ->
    #     {{ax, ay}, {bx, by}, {px, py}}
    # end
    case lines do
      [a, b, p] ->
        [ax, ay] = Util.extract_ints(a)
        [bx, by] = Util.extract_ints(b)
        [px, py] = Util.extract_ints(p)
        {{ax, ay}, {bx, by}, {px, py}}
    end
  end

  def main(input_file) do
    instrs = Util.read_lines(input_file) |> Util.split_on("") |> Enum.map(&parse_line/1)
    # Util.inspect(instrs)

    # Util.inspect("Button A: X+94, Y+34" |> Util.extract_ints())
    part1 = instrs |> Enum.map(&solve1/1) |> Enum.sum()
    IO.inspect(part1)
    trouble = instrs |> Enum.filter(fn {{ax, ay}, {bx, by}, _} -> ax * by == ay * bx end)
    IO.inspect(trouble |> Enum.count())
  end
end
