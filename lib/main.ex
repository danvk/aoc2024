defmodule Main do
  def main(args) do
    [day_str, file] = args
    day = String.to_integer(day_str)

    case day do
      1 -> Day1.main(file)
      2 -> Day2.main(file)
      3 -> Day3.main(file)
      # -- next day here --
      _ -> IO.puts("Unknown day: #{day}")
    end
  end
end
