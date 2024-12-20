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

  def step_robots(robots) do
    for {p, v} <- robots, do: {step(p, v), v}
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

  def is_symmetric(robots) do
    positions = robots |> Enum.map(&Util.first/1)
    quads = positions |> Util.count_by(&quadrant/1)
    # and really_symmetric(positions)
    quads[1] == quads[2] and quads[3] == quads[4]
  end

  def really_symmetric(positions) do
    grid =
      for p <- positions, reduce: %{} do
        acc -> Map.put(acc, p, ?#)
      end

    positions |> Enum.all?(fn {x, y} -> Map.get(grid, {@width - 1 - x, y}) == ?# end)
  end

  def print_robots(robots) do
    grid =
      for {p, _} <- robots, reduce: %{} do
        acc -> Map.put(acc, p, ?#)
      end

    Util.print_grid(grid, {@width - 1, @height - 1})
  end

  def robot_hash(robots) do
    positions = robots |> Enum.map(&Util.first/1)
    pos_txt = for({x, y} <- positions, do: "#{x},#{y}") |> Enum.join(";")
    :crypto.hash(:md5, pos_txt) |> Base.encode16(case: :lower)
  end

  def similar_line_counts(robots) do
    positions = robots |> Enum.map(&Util.first/1)
    by_y = positions |> Util.count_by(&Util.second/1)
    by_y[2] == by_y[3] and by_y[3] == by_y[4] and by_y[4] == by_y[5]
  end

  @dirs [
    {1, 0},
    {-1, 0},
    {0, 1},
    {0, -1},
    {1, 1},
    {-1, -1},
    {1, -1},
    {-1, 1}
  ]

  def num_with_neighbor(robots) do
    positions = robots |> Enum.map(&Util.first/1)

    grid =
      for p <- positions, reduce: %{} do
        acc -> Map.put(acc, p, ?#)
      end

    positions
    |> Enum.filter(fn {x, y} ->
      Enum.any?(@dirs, fn {dx, dy} -> Map.get(grid, {x + dx, y + dy}) == ?# end)
    end)
    |> Enum.count()
  end

  def main(input_file) do
    robots = Util.read_lines(input_file) |> Enum.map(&parse_line/1)
    # Util.inspect(robots)

    after100 = for {p, v} <- robots, do: step100(p, v)

    quadrants =
      after100 |> Util.count_by(&quadrant/1)

    part1 = 1..4 |> Enum.map(&quadrants[&1]) |> Enum.product()

    Util.inspect(part1)

    1..(@height * @width)
    # 1..100
    |> Enum.reduce({robots, %{}}, fn n, {r, seen} ->
      r = step_robots(r)
      # IO.puts(n)
      # print_robots(r)
      # IO.puts("")
      # hash = robot_hash(r)

      # if Map.get(seen, hash) do
      #   IO.puts("Repeat after #{n}")
      # end

      if is_symmetric(r) do
        IO.puts("#{n} is symmetric")
        # print_robots(r)
      end

      if similar_line_counts(r) do
        IO.puts("#{n} has similar line counts")
        # print_robots(r)
      end

      if num_with_neighbor(r) > 300 do
        IO.puts("#{n} has many neighbors")
        print_robots(r)
      end

      # if Integer.mod(n, 10000) == 0 do
      #   IO.puts("#{n}...")
      # end

      # {r, Map.put(seen, hash, true)}
      {r, seen}
    end)
  end
end
