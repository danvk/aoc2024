defmodule Search do
  def a_star(starts, target, neighbors_fn) do
    queue =
      starts
      |> Enum.map(fn start -> {0, start} end)
      |> Enum.into(Heap.new(fn {d1, _}, {d2, _} -> d1 < d2 end))

    a_star_help(queue, target, %{}, neighbors_fn)
  end

  def a_star_help(queue, target, visited, n_fn) do
    # Util.inspect(queue |> Enum.into([]))

    cond do
      Heap.empty?(queue) -> nil
      true -> a_star_help2(queue, target, visited, n_fn)
    end
  end

  def a_star_help2(queue, target, visited, n_fn) do
    {{d, v}, rest} = Heap.split(queue)
    # Util.inspect(d, v)

    cond do
      target.(v) ->
        d

      Map.get(visited, v) ->
        a_star_help(rest, target, visited, n_fn)

      true ->
        nexts = n_fn.(v)
        # IO.inspect(nexts)
        d_nexts = nexts |> Enum.map(fn {nd, nv} -> {d + nd, nv} end)
        # IO.inspect(d_nexts)
        next_queue = d_nexts |> Enum.reduce(rest, fn next, h -> Heap.push(h, next) end)
        # IO.puts("next heap")
        # Util.inspect(next_queue |> Enum.into([]))
        next_visited = Map.put(visited, v, d)
        a_star_help(next_queue, target, next_visited, n_fn)
    end
  end
end
