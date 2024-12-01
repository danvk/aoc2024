defmodule Day2 do
  @size1 3
  @codes1 [
    "123",
    "456",
    "789"
  ]

  @size2 5
  @codes2 [
    "  1  ",
    " 234 ",
    "56789",
    " ABC ",
    "  D  "
  ]

  def move(dir, {x, y}, size) do
    case dir do
      ?U -> {x, max(0, y - 1)}
      ?D -> {x, min(size - 1, y + 1)}
      ?L -> {max(0, x - 1), y}
      ?R -> {min(size - 1, x + 1), y}
    end
  end

  def move_n(dir, {x, y}, which) do
    new_pos = move(dir, {x, y}, if which == 1 do @size1 else @size2 end)
    code = code_at(new_pos, which)
    case code do
      " " -> {x, y}
      _ -> new_pos
    end
  end

  def code_at({x, y}, which) do
    String.at(Enum.at(if which == 1 do @codes1 else @codes2 end, y), x)
  end

  def apply_instrs(instrs, pos, which) do
    Enum.reduce(instrs, pos, &move_n(&1, &2, which))
  end
end

input_file = hd(System.argv())
instrs = Common.read_lines(input_file) |> Enum.map(&String.to_charlist/1)

IO.inspect(instrs)

poses1 = Common.accumulate(instrs, &Day2.apply_instrs(&1, &2, 1), {1, 1})
codes1 = Enum.map(poses1, &Day2.code_at(&1, 1))
IO.puts("Part 1: #{Enum.join(codes1)}")

poses2 = Common.accumulate(instrs, &Day2.apply_instrs(&1, &2, 2), {0, 2})
IO.inspect(poses2)
codes2 = Enum.map(poses2, &Day2.code_at(&1, 2))
IO.puts("Part 2: #{Enum.join(codes2)}")
