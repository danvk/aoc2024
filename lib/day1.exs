defmodule Day1 do
  def parse_line(line) do
    String.split(line)
  end

  def main(args) do
    input_file = hd(args)
    instrs = Util.read_lines(input_file) |> Enum.map(&parse_line/1)
    IO.inspect(instrs)
  end
end

