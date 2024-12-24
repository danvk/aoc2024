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

  defp inputs_for(graph, wire, acc \\ MapSet.new()) do
    case graph[wire] do
      {_, left, right} ->
        inputs_for(graph, left, inputs_for(graph, right, acc))

      nil ->
        MapSet.put(acc, wire)
    end
  end

  def two_digits(n), do: n |> Integer.to_string() |> String.pad_leading(2, "0")

  def check_inputs(graph, z) do
    z_wire = "z" <> two_digits(z)
    inputs = inputs_for(graph, z_wire)
    expected = for let <- ["x", "y"], n <- 0..z, into: MapSet.new(), do: let <> two_digits(n)

    missing = MapSet.difference(expected, inputs)

    if !Enum.empty?(missing) do
      ms = missing |> MapSet.to_list() |> Enum.join(", ")
      IO.puts("#{z_wire} is missing expected inputs: #{ms}")
    end

    extra = MapSet.difference(inputs, expected)

    if !Enum.empty?(extra) do
      ms = extra |> MapSet.to_list() |> Enum.join(", ")
      IO.puts("#{z_wire} has unexpected inputs: #{ms}")
    end
  end

  def main(input_file) do
    {wire_lines, circuit_lines} = Util.read_lines(input_file) |> Util.split_on_blank()

    wires = wire_lines |> Enum.map(&parse_wire/1)
    circuits = circuit_lines |> Enum.map(&parse_circuit/1)

    graph1 = Enum.into(wires ++ circuits, %{})
    # Util.inspect(graph1)

    outs =
      Map.keys(graph1)
      |> Enum.filter(&String.starts_with?(&1, "z"))
      |> Enum.map(&{&1, evaluate(graph1, &1)})
      |> Enum.sort()

    # Util.inspect(outs)
    part1 = to_num(outs)
    IO.puts("part 1: #{part1}")

    graph = Enum.into(circuits, %{})
    # Util.inspect("z00", inputs_for(graph, "z00"))
    # Util.inspect("z01", inputs_for(graph, "z01"))
    # Util.inspect("z02", inputs_for(graph, "z02"))
    # Util.inspect("z03", inputs_for(graph, "z03"))
    # Util.inspect("z04", inputs_for(graph, "z04"))

    for z <- 0..44, do: check_inputs(graph, z)
  end
end
