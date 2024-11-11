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
        new_pos = move(pos, {dir, d})
        {new_pos, new_dir}
    end

    def norm1({x, y}) do
        abs(x) + abs(y)
    end
end

contents = File.read!("day1/input.txt")
IO.puts(contents)

steps_str = String.split(contents, ", ")
IO.inspect(steps_str)

moves = Enum.map(steps_str, &Day1.parse_instr/1)
IO.inspect(moves)

{pos, _} = List.foldr(moves, {{0, 0}, :N}, &Day1.apply_instr/2)
IO.inspect(pos)
IO.puts("Solution #{Day1.norm1(pos)}")
