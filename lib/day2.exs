defmodule Day2 do

  @size 4

  @codes [
    "  1  ",
    " 234 ",
    "56789",
    " ABC ",
    "  D  "
  ]

  def move(dir, {x, y}) do
    case dir do
      ?U -> {x, max(0, y - 1)}
      ?D -> {x, min(@size, y + 1)}
      ?L -> {max(0, x - 1), y}
      ?R -> {min(@size, x + 1), y}
    end
  end

  def move2(dir, {x, y}) do
    new_pos = move(dir, {x, y})
    code = code_at(new_pos)
    case code do
      " " -> {x, y}
      _ -> new_pos
    end
  end

  def code_at({x, y}) do
    String.at(Enum.at(@codes, y), x)
  end

  def apply_instrs(instrs, pos) do
    Enum.reduce(instrs, pos, &move2/2)
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
pos = Enum.reduce(instr, {0, 2}, &Day2.move2/2)
IO.inspect(pos)
IO.puts("Part 1: #{elem(pos, 0)},#{elem(pos, 1)} #{Day2.code_at(pos)}")

poses = Day2.accumulate(instrs, &Day2.apply_instrs/2, {0, 2})
IO.inspect(poses)
codes = Enum.map(poses, &Day2.code_at/1)
IO.inspect(codes)
