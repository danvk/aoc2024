# https://adventofcode.com/2024/day/23
defmodule Day23 do
  defp parse_line(line) do
    [a, b] = String.split(line, "-")
    ordered({a, b})
  end

  defp ordered({a, b}) do
    if a < b, do: {a, b}, else: {b, a}
  end

  defp contains?(graph, link) do
    MapSet.member?(graph, ordered(link))
  end

  defp fully_connected_to_cluster(graph, cluster, node) do
    Enum.all?(cluster |> Enum.map(&contains?(graph, {&1, node})))
  end

  defp expand_clusters(graph, nodes, clusters) do
    # clusters is a list of sorted lists of fully-connected nodes
    for cluster <- clusters, n when n < hd(cluster) <- nodes, reduce: [] do
      acc ->
        if fully_connected_to_cluster(graph, cluster, n) do
          [[n | cluster] | acc]
        else
          acc
        end
    end
    |> Enum.reject(&(&1 == nil))
  end

  defp with_t(triples) do
    triples
    |> Enum.filter(fn nodes -> Enum.any?(nodes, &String.starts_with?(&1, "t")) end)
  end

  defp keep_expanding(graph, nodes, n, clusters) do
    # Given a list of fully-connected clusters of size n, make clusters of size n + 1
    new_clusters = expand_clusters(graph, nodes, clusters)

    case new_clusters do
      [] ->
        clusters

      _ ->
        count = Enum.count(new_clusters)
        IO.puts("n: #{n + 1}, num: #{count}")
        keep_expanding(graph, nodes, n + 1, new_clusters)
    end
  end

  def main(input_file) do
    graph = Util.read_lines(input_file) |> Enum.map(&parse_line/1) |> Enum.into(MapSet.new())
    nodes = for {a, b} <- graph, n <- [a, b], do: n, uniq: true
    two_clusters = for {a, b} <- graph, do: [a, b]

    triples = expand_clusters(graph, nodes, two_clusters)
    part1 = with_t(triples) |> Enum.count()
    IO.puts("part 1: #{part1}")

    IO.puts("n: 2, num: #{Enum.count(two_clusters)}")
    [biggest] = keep_expanding(graph, nodes, 2, two_clusters)
    part2 = biggest |> Enum.join(",")
    IO.puts("part 2: #{part2}")
  end
end
