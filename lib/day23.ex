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

  def with_t(triples) do
    for (
      {a, b, c} <- triples,
      do:
        if(String.contains?(a, "t") or String.contains?(b, "t") or String.contains?(c, "t")) do
          {a, b, c}
        else
          nil
        end
    )
    |> Enum.reject(&(&1 == nil))
  end

  def main(input_file) do
    graph = Util.read_lines(input_file) |> Enum.map(&parse_line/1) |> Enum.into(MapSet.new())
    nodes = for {a, b} <- graph, n <- [a, b], do: n, uniq: true
    triples = find_triples(graph, nodes)
    Util.inspect(triples)
    # Util.inspect(nodes)
  end
end
