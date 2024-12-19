# https://adventofcode.com/2024/day/17
defmodule Day17 do
  # State:
  # Instruction Pointer
  # Registers A, B, C

  defmodule State do
    @enforce_keys [:ip, :a, :b, :c]
    defstruct [:ip, :a, :b, :c]
  end

  # Opcodes:
  # 0=adv/combo:   floor(A / 2^operand) -> A
  # 1=bxl/literal: B ^ operand -> B
  # 2=bst/combo:   operand % 8 -> B
  # 3=jnz/literal: if A != 0 then jump to operand
  # 4=bxc/ignore:  B ^ C -> B
  # 5=out/combo:   output(operand % 8)
  # 6=bdv/combo:   floor(A / 2^operand) -> B
  # 7=cdv/combo:   floor(A / 2^operand) -> C

  def parse_line(line) do
    String.split(line)
  end

  def main(input_file) do
    {registers, code} = Util.read_lines(input_file) |> Util.split_on_blank()
    [a, b, c] = Util.extract_ints(registers |> Enum.join(" "))
    state = %State{ip: 0, a: a, b: b, c: c}
    nums = Util.read_ints(code, ",")
    Util.inspect(state)
    Util.inspect(nums)
  end
end
