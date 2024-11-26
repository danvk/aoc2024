defmodule Day2 do
  def move(dir, {x, y}) do
    case dir do
      ?U -> {x, max(0, y - 1)}
      ?D -> {x, min(2, y + 1)}
      ?L -> {max(0, x - 1), y}
      ?R -> {min(2, x + 1), y}
    end
  end

  def code_at({x, y}) do
    case {x, y} do
      {0, 0} -> "1"
      {1, 0} -> "2"
      {2, 0} -> "3"
      {0, 1} -> "4"
      {1, 1} -> "5"
      {2, 1} -> "6"
      {0, 2} -> "7"
      {1, 2} -> "8"
      {2, 2} -> "9"
    end
  end

  def apply_instrs(instrs, pos) do
    Enum.reduce(instrs, pos, &move/2)
  end

  def accumulate(xs, f, acc) do
    # TODO: make this O(n) instead of O(n^2)
    {_, seq} = Enum.reduce(xs, {acc, []}, fn x, {acc, accs} ->
      new_acc = f.(x, acc)
      {new_acc, accs ++ [new_acc]}
    end)
    seq
  end
end

input_file = hd(System.argv())
contents = File.read!(input_file)
instructions_txt = String.split(contents, "\n")
instrs = Enum.map(instructions_txt, &String.to_charlist/1)

IO.inspect(instrs)

instr = hd(instrs)
pos = Enum.reduce(instr, {1, 1}, &Day2.move/2)
IO.inspect(pos)
IO.puts("Part 1: #{elem(pos, 0)},#{elem(pos, 1)} #{Day2.code_at(pos)}")

poses = Day2.accumulate(instrs, &Day2.apply_instrs/2, {1, 1})
IO.inspect(poses)
codes = Enum.map(poses, &Day2.code_at/1)
IO.inspect(codes)
