# https://adventofcode.com/2024/day/24
defmodule Day24 do
  defp parse_wire(line) do
    [wire, value_str] = String.split(line, ": ")

    val =
      case value_str do
        "0" -> false
        "1" -> true
      end

    {wire, {:num, val}}
  end

  defp parse_circuit(line) do
    [lhs_str, wire_out] = String.split(line, " -> ")

    lhs =
      case String.split(lhs_str, " ") do
        [left, "AND", right] -> {:and, left, right}
        [left, "XOR", right] -> {:xor, left, right}
        [left, "OR", right] -> {:or, left, right}
      end

    {wire_out, lhs}
  end

  defp xor(a, b) do
    (a and not b) or (b and not a)
  end

  defp evaluate(graph, wire) do
    case graph[wire] do
      {:num, val} -> val
      {:and, left, right} -> evaluate(graph, left) and evaluate(graph, right)
      {:or, left, right} -> evaluate(graph, left) or evaluate(graph, right)
      {:xor, left, right} -> xor(evaluate(graph, left), evaluate(graph, right))
    end
  end

  defp to_num([]), do: 0
  defp to_num([{_, false} | rest]), do: to_num(rest)

  defp to_num([{wire, true} | rest]) do
    if not String.starts_with?(wire, "z") do
      raise "Invalid wire #{wire}"
    end

    n = String.slice(wire, 1..-1//1) |> String.to_integer()
    Integer.pow(2, n) + to_num(rest)
  end

  def main(input_file) do
    {wire_lines, circuit_lines} = Util.read_lines(input_file) |> Util.split_on_blank()

    wires = wire_lines |> Enum.map(&parse_wire/1)
    circuits = circuit_lines |> Enum.map(&parse_circuit/1)

    graph = Enum.into(wires ++ circuits, %{})
    Util.inspect(graph)

    outs =
      Map.keys(graph)
      |> Enum.filter(&String.starts_with?(&1, "z"))
      |> Enum.map(&{&1, evaluate(graph, &1)})
      |> Enum.sort()

    Util.inspect(outs)
    Util.inspect(to_num(outs))
  end
end
