defmodule Day16 do
  def parse_line(line) do
    String.split(line)
  end

  def main(input_file) do
    {grid, wh} = Util.read_grid(input_file)
    {grid, start} = Util.find_and_replace_char_in_grid(grid, ?S, ?.)
    {grid, finish} = Util.find_and_replace_char_in_grid(grid, ?E, ?.)

    Util.print_grid(grid, wh)
    Util.inspect(start, finish)
  end
end
