# https://adventofcode.com/2024/day/10
defmodule Day10 do
  def neighbors({x, y}) do
    [
      {x + 1, y},
      {x - 1, y},
      {x, y - 1},
      {x, y + 1}
    ]
  end

  def make_graph(m) do
    for {p, v} <- m, into: %{}, do: {p, neighbors(p) |> Enum.filter(&(Map.get(m, &1) == v + 1))}
  end

  def bfs(graph, start) do
    queue = [start]
    visited = MapSet.new()

    bfs_help(graph, queue, visited)
  end

  def bfs_help(_, [], visited) do
    visited
  end

  def bfs_help(graph, queue, visited) do
    [p | rest] = queue

    cond do
      MapSet.member?(visited, p) ->
        bfs_help(graph, rest, visited)

      true ->
        visited = MapSet.put(visited, p)
        bfs_help(graph, rest ++ graph[p], visited)
    end
  end

  def peaks_for_start(map, graph, start) do
    visited = bfs(graph, start)
    visited |> Enum.filter(fn p -> map[p] == 9 end)
  end

  def bfs2(graph, start) do
    queue = [start]
    visit_counts = %{}
    bfs2_help(graph, queue, visit_counts)
  end

  def bfs2_help(_, [], visit_counts) do
    visit_counts
  end

  def bfs2_help(graph, queue, visit_counts) do
    [p | rest] = queue

    {_, visit_counts} =
      Map.get_and_update(visit_counts, p, fn v ->
        {v,
         if v do
           v
         else
           0
         end + 1}
      end)

    # Util.inspect(visit_counts)

    bfs2_help(graph, rest ++ graph[p], visit_counts)
  end

  def rating_for_start(map, graph, start) do
    visited = bfs2(graph, start)

    visited
    |> Enum.filter(fn {p, _c} -> map[p] == 9 end)
    |> Enum.map(&Util.second/1)
    |> Enum.sum()
  end

  def main(input_file) do
    {map, _wh} = Util.read_grid(input_file)
    map = Map.new(map, fn {k, v} -> {k, v - ?0} end)
    graph = make_graph(map)
    # Util.inspect(wh, map)
    # Util.inspect(graph)
    # Util.inspect(bfs(graph, {0, 0}))

    starts = map |> Enum.filter(fn {_p, v} -> v == 0 end) |> Enum.map(&Util.first/1)

    part1 =
      starts |> Enum.map(fn p -> peaks_for_start(map, graph, p) |> Enum.count() end) |> Enum.sum()

    Util.inspect(part1)

    part2 =
      starts
      |> Enum.map(fn p -> rating_for_start(map, graph, p) end)
      |> Enum.sum()

    Util.inspect(part2)
  end
end
