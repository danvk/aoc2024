defmodule Main do
  def main(args) do
    [day_str, file] = args
    day = String.to_integer(day_str)

    case day do
      1 -> Day1.main(file)
      2 -> Day2.main(file)
      3 -> Day3.main(file)
      4 -> Day4.main(file)
      5 -> Day5.main(file)
      6 -> Day6.main(file)
      7 -> Day7.main(file)
      8 -> Day8.main(file)
      9 -> Day9.main(file)
      10 -> Day10.main(file)
      11 -> Day11.main(file)
      12 -> Day12.main(file)
      13 -> Day13.main(file)
      14 -> Day14.main(file)
      15 -> Day15.main(file)
      16 -> Day16.main(file)
      17 -> Day17.main(file)
      18 -> Day18.main(file)
      19 -> Day19.main(file)
      # -- next day here --
      _ -> IO.puts("Unknown day: #{day}")
    end
  end
end
