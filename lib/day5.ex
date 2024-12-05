# https://adventofcode.com/2024/day/5
defmodule Day5 do
  def parse_line(line) do
    String.split(line)
  end

  def split_on_blank(lines) do
    {a, ["" | b]} = lines |> Enum.split_while(&(&1 != ""))
    {a, b}
  end

  def is_valid(input, rule_pairs) do
    after_to_before = filter_rules(rule_pairs, input)
    # IO.inspect(after_to_before, charlists: false)

    {_prev, is_ok} =
      input
      |> Enum.reduce({[], true}, fn x, {prev, ok} ->
        reqs = Map.get(after_to_before, x, [])
        # IO.inspect(reqs)
        is_ok = reqs |> Enum.all?(fn y -> Enum.find(prev, &(&1 == y)) != nil end)
        # IO.inspect(reqs, charlists: false)
        # IO.inspect(x)
        # IO.inspect(is_ok)

        case ok do
          false -> {[], false}
          true -> {[x | prev], is_ok}
        end
      end)

    is_ok
  end

  def filter_rules(rule_pairs, input) do
    present = for x <- input, into: %{}, do: {x, true}

    filtered =
      rule_pairs
      # |> IO.inspect(charlists: false)
      |> Enum.filter(fn [a, b] -> present[a] && present[b] end)

    filtered |> Enum.group_by(&Util.second/1, &Util.first/1)
  end

  def get_middle(xs) do
    xs |> Enum.at(floor(((xs |> Enum.count()) - 1) / 2))
  end

  def fix_input(rule_pairs, input) do
    filtered = filter_rules(rule_pairs, input)

    input
    |> Enum.sort_by(fn v -> Map.get(filtered, v, []) |> Enum.count() end)
  end

  def main(input_file) do
    {rules, inputs_txt} = Util.read_lines(input_file) |> split_on_blank()

    rule_pairs =
      for rule <- rules,
          do: rule |> String.split("|") |> Enum.map(&String.to_integer/1)

    # after_to_before = rule_pairs |> Enum.group_by(&Util.second/1, &Util.first/1)
    # IO.inspect(after_to_before, charlists: false)

    inputs =
      for input <- inputs_txt, do: input |> String.split(",") |> Enum.map(&String.to_integer/1)

    IO.inspect(inputs, charlists: false)
    {valids, invalids} = Enum.split_with(inputs, &is_valid(&1, rule_pairs))
    # valids = inputs |> Enum.filter(&is_valid(&1, rule_pairs))
    IO.inspect(valids, charlists: false)
    part1 = valids |> Enum.map(&get_middle/1) |> Enum.sum()
    IO.puts(part1)

    fixed = invalids |> Enum.map(&fix_input(rule_pairs, &1)) |> IO.inspect(charlists: false)
    part2 = fixed |> Enum.map(&get_middle/1) |> Enum.sum()
    IO.puts(part2)
  end
end
