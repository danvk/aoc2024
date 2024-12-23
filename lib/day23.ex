# https://adventofcode.com/2024/day/23
defmodule Day23 do
  defp parse_line(line) do
    [a, b] = String.split(line, "-")
    ordered({a, b})
  end

  def ordered({a, b}) do
    if a < b, do: {a, b}, else: {b, a}
  end

  def contains?(graph, link) do
    MapSet.member?(graph, ordered(link))
  end

  def find_triples(graph, nodes) do
    for(
      {a, b} <- graph,
      c when c > b <- nodes,
      do:
        if(contains?(graph, {b, c}) and contains?(graph, {a, c})) do
          {a, b, c}
        else
          nil
        end
    )
    |> Enum.reject(&(&1 == nil))
  end

  def expand_clusters(graph, nodes, clusters) do
    # clusters is a list of sorted lists of fully-connected nodes
    for cluster <- clusters, n when n < hd(cluster) <- nodes do
      if Enum.all?(cluster |> Enum.map(&contains?(graph, {&1, n}))) do
        [n | cluster]
      else
        nil
      end
    end
    |> Enum.reject(&(&1 == nil))
  end

  def is_t(a, b, c) do
    String.starts_with?(a, "t") or String.starts_with?(b, "t") or String.starts_with?(c, "t")
  end

  def with_t(triples) do
    for(
      {a, b, c} when a < b and b < c <- triples,
      do: if(is_t(a, b, c), do: "#{a}-#{b}-#{c}", else: nil)
    )
    |> Enum.reject(&(&1 == nil))
  end

  def keep_expanding(graph, nodes, n, clusters) do
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
    triples = find_triples(graph, nodes)
    # Util.inspect(triples)
    with_t(triples) |> Enum.map(&IO.puts(&1))
    # Util.inspect(nodes)
    Util.inspect(with_t(triples) |> Enum.count())

    two_clusters = for {a, b} <- graph, do: [a, b]
    [biggest] = keep_expanding(graph, nodes, 2, two_clusters)
    Util.inspect(biggest |> Enum.join(","))
    # three_clusters = expand_clusters(graph, nodes, two_clusters)
    # four_clusters = expand_clusters(graph, nodes, three_clusters)
    # Util.inspect(four_clusters)
    # Util.inspect(Enum.count(four_clusters))
  end
end
