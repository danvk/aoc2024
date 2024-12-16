# https://adventofcode.com/2024/day/14
defmodule Day14 do
  @width 101
  @height 103

  def parse_line(line) do
    [p, v] = line |> String.split(" ")
    [px, py] = p |> String.slice(2..-1//1) |> Util.read_ints(",")
    [vx, vy] = v |> String.slice(2..-1//1) |> Util.read_ints(",")
    {{px, py}, {vx, vy}}
  end

  def step({px, py}, {vx, vy}) do
    {
      Integer.mod(px + vx, @width),
      Integer.mod(py + vy, @height)
    }
  end

  def step100(p, v) do
    Enum.reduce(1..100, p, fn _, p -> step(p, v) end)
  end

  def quadrant({x, y}) do
    dx = 2 * x + 1
    dy = 2 * y + 1

    xq =
      cond do
        dx < @width -> -1
        dx > @width -> 1
        true -> 0
      end

    yq =
      cond do
        dy < @height -> -1
        dy > @height -> 1
        true -> 0
      end

    case {xq, yq} do
      {0, _} -> nil
      {_, 0} -> nil
      {-1, -1} -> 1
      {1, -1} -> 2
      {-1, 1} -> 3
      {1, 1} -> 4
    end
  end

  def main(input_file) do
    robots = Util.read_lines(input_file) |> Enum.map(&parse_line/1)
    # Util.inspect(robots)

    after100 = for {p, v} <- robots, do: step100(p, v)

    quadrants =
      after100 |> Enum.group_by(&quadrant/1) |> Util.map_values(fn _k, v -> Enum.count(v) end)

    part1 = 1..4 |> Enum.map(&quadrants[&1]) |> Enum.product()

    Util.inspect(part1)
  end
end
