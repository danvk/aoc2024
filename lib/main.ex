defmodule Main do
  def main(args) do
    [day_str, file] = args
    day = String.to_integer(day_str)

    case day do
      1 -> Day1.main(file)
      # -- next day here --
      _ -> IO.puts("Unknown day: #{day}")
    end
  end
end
