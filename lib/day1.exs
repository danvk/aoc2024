defmodule Day1 do
    def parse_instr(str) do
        {direction, distance} = String.split_at(str, 1)
        d = String.to_integer(distance)
        case direction do
            "R" -> {:R, d}
            "L" -> {:L, d}
        end
    end

    # Move d units in the direction dir
    def move({x, y}, {dir, d}) do
        case dir do
            :E -> {x + d, y}
            :W -> {x - d, y}
            :N -> {x, y - d}
            :S -> {x, y + d}
        end
    end

    def turn(dir, turn) do
        case {dir, turn} do
            {:E, :R} -> :S
            {:E, :L} -> :N
            {:W, :R} -> :N
            {:W, :L} -> :S
            {:N, :R} -> :E
            {:N, :L} -> :W
            {:S, :R} -> :W
            {:S, :L} -> :E
        end
    end

    def apply_instr({t, d}, {pos, dir}) do
        new_dir = turn(dir, t)
        new_pos = move(pos, {new_dir, d})
        IO.puts("#{t}#{d}: (#{elem(pos, 0)},#{elem(pos, 1)}),#{dir} -> (#{elem(new_pos, 0)},#{elem(new_pos, 1)}),#{new_dir}")
        {new_pos, new_dir}
    end

    def norm1({x, y}) do
        abs(x) + abs(y)
    end

    def first_duplicate(seq) do
        Enum.reduce_while(seq, %{}, fn
            v, seen ->
                case Map.has_key?(seen, v) do
                    true -> {:halt, v}
                    false -> {:cont, Map.put(seen, v, true)}
                end
        end)
    end
end

input_file = hd(System.argv())

contents = File.read!(input_file)
# IO.puts(contents)

steps_str = String.split(contents, ", ")
IO.inspect(steps_str)

moves = Enum.map(steps_str, &Day1.parse_instr/1)
# IO.inspect(moves)

{pos, _} = Enum.reduce(moves, {{0, 0}, :N}, &Day1.apply_instr/2)
IO.inspect(pos)
IO.puts("Part 1: #{Day1.norm1(pos)}")

IO.puts(Day1.first_duplicate([1, 2, 1, 3, 4, 2]))

result = Enum.reduce_while(moves, {{{0, 0}, :N}, %{}}, fn ({turn, d}, {{pos, dir}, visited}) ->
    new_dir = Day1.turn(dir, turn)
    state = Enum.reduce_while(1..d, {pos, visited}, fn _, {pos, visited} ->
        new_pos = Day1.move(pos, {new_dir, 1})
        case Map.has_key?(visited, new_pos) do
            true -> {:halt, {:halt, new_pos}}
            false -> {:cont, {new_pos, Map.put(visited, new_pos, true)}}
        end
    end)
    case state do
        {:halt, pos} -> {:halt, pos}
        {pos, visited} -> {:cont, {{pos, new_dir}, visited}}
    end
end)

IO.inspect(result)
IO.puts("Part 2: #{Day1.norm1(result)}")
