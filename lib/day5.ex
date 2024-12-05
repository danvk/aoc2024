# https://adventofcode.com/2024/day/5
defmodule Day5 do
  def is_valid(input, rule_pairs) do
    after_to_before = filter_rules(rule_pairs, input)

    {_prev, is_ok} =
      input
      |> Enum.reduce({[], true}, fn x, {prev, ok} ->
        reqs = Map.get(after_to_before, x, [])

        if ok do
          is_ok = reqs |> Enum.all?(fn y -> Enum.find(prev, &(&1 == y)) != nil end)
          {[x | prev], is_ok}
        else
          {[], false}
        end
      end)

    is_ok
  end

  def filter_rules(rule_pairs, input) do
    present = for x <- input, into: %{}, do: {x, true}

    filtered =
      rule_pairs
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
    {rules, inputs_txt} = Util.read_lines(input_file) |> Util.split_on_blank()

    rule_pairs = for rule <- rules, do: Util.read_ints(rule, "|")
    inputs = for input <- inputs_txt, do: Util.read_ints(input, ",")

    {valids, invalids} = Enum.split_with(inputs, &is_valid(&1, rule_pairs))
    part1 = valids |> Enum.map(&get_middle/1) |> Enum.sum()
    IO.puts(part1)

    fixed = invalids |> Enum.map(&fix_input(rule_pairs, &1))
    part2 = fixed |> Enum.map(&get_middle/1) |> Enum.sum()
    IO.puts(part2)
  end
end
