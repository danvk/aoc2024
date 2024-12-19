# https://adventofcode.com/2024/day/17
defmodule Day17 do
  # State:
  # Instruction Pointer
  # Registers A, B, C

  defmodule State do
    @enforce_keys [:ip, :a, :b, :c, :out]
    defstruct [:ip, :a, :b, :c, :out, halted: false]
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
  @adv 0
  @bxl 1
  @bst 2
  @jnz 3
  @bxc 4
  @out 5
  @bdv 6
  @cdv 7

  def advance(state, codes, n_codes) do
    cond do
      state.ip + 1 >= n_codes ->
        %{state | halted: true}

      true ->
        [opcode, operand] = Enum.drop(codes, state.ip) |> Enum.slice(0..1)
        new_state = run_op(opcode, operand, state)
        %{new_state | ip: new_state.ip + 2}
    end
  end

  def run_op(@adv, operand, state) do
    %{state | a: floor(state.a / Integer.pow(2, combo(operand, state)))}
  end

  def run_op(@bdv, operand, state) do
    %{state | b: floor(state.a / Integer.pow(2, combo(operand, state)))}
  end

  def run_op(@cdv, operand, state) do
    %{state | c: floor(state.a / Integer.pow(2, combo(operand, state)))}
  end

  def run_op(@bxl, operand, state) do
    %{state | b: Bitwise.bxor(state.b, operand)}
  end

  def run_op(@bst, operand, state) do
    %{state | b: Integer.mod(combo(operand, state), 8)}
  end

  def run_op(@jnz, operand, state) do
    %{state | ip: if(state.a != 0, do: operand - 2, else: state.ip)}
  end

  def run_op(@bxc, _operand, state) do
    %{state | b: Bitwise.bxor(state.b, state.c)}
  end

  def run_op(@out, operand, state) do
    %{state | out: state.out ++ [Integer.mod(operand, 8)]}
  end

  def combo(operand, state) do
    case operand do
      # any more concise way to match 0..3?
      0 -> operand
      1 -> operand
      2 -> operand
      3 -> operand
      4 -> state.a
      5 -> state.b
      6 -> state.c
      7 -> raise("invalid program")
    end
  end

  def run_program(codes, state) do
    n_codes = codes |> Enum.count()
    run_program_help(codes, state, n_codes)
  end

  def run_program_help(codes, state, n_codes) do
    case state.halted do
      true -> state
      false -> run_program_help(codes, advance(state, codes, n_codes), n_codes)
    end
  end

  def main(input_file) do
    {registers, code} = Util.read_lines(input_file) |> Util.split_on_blank()
    [a, b, c] = Util.extract_ints(registers |> Enum.join(" "))
    state = %State{ip: 0, a: a, b: b, c: c, out: []}
    nums = Util.extract_ints(code |> Enum.join(" "))
    Util.inspect(state)
    Util.inspect(nums)

    Util.inspect(run_program(nums, state))
  end
end
