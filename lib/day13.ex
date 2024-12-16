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

  def solve_eq({{ax, ay}, {bx, by}, {px, py}}) do
    # B = (px - ax * A) / bx
    # by * ax * A + by * bx * B = by * px
    # bx * ay * A + bx * by * B = bx * py
    # ay * ax * A + ay * bx * B = ay * px
    # ax * ay * A + ax * by * B = ax * py
    # B = (ay * px - ax * py) / (ay * bx - ax * by)
    a = (by * px - bx * py) / (by * ax - bx * ay)
    b = (ay * px - ax * py) / (ay * bx - ax * by)
    {a, b}
  end

  def filter1({a, b}) do
    filter2({a, b}) && a <= 100 && b <= 100
  end

  def filter2({a, b}) do
    a >= 0 && b >= 0 && is_int(a) && is_int(b)
  end

  def score({a, b}) do
    3 * a + b
  end

  def is_int(x) do
    floor(x) == x
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
    # part1 = instrs |> Enum.map(&solve1/1) |> Enum.sum()
    # IO.inspect(part1)
    trouble = instrs |> Enum.filter(fn {{ax, ay}, {bx, by}, _} -> ax * by == ay * bx end)
    IO.inspect(trouble |> Enum.count())

    part1 = instrs |> Enum.map(&solve_eq/1)
    # IO.inspect(part1)
    IO.inspect(part1 |> Enum.filter(&filter1/1) |> Enum.map(&score/1) |> Enum.sum())

    machines2 =
      instrs
      |> Enum.map(fn {a, b, {px, py}} ->
        {a, b, {10_000_000_000_000 + px, 10_000_000_000_000 + py}}
      end)

    IO.inspect(
      machines2
      |> Enum.map(&solve_eq/1)
      |> Enum.filter(&filter2/1)
      |> Enum.map(&score/1)
      |> Enum.sum()
    )
  end
end
