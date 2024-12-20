defmodule Search16 do
  # variation on search to return _all_ paths to target up to a distance.
  def a_star(starts, target, max_d, neighbors_fn) do
    # The heap contains {distance, prev tuple, state} tuples.
    queue =
      starts
      |> Enum.map(fn start -> {0, nil, start} end)
      |> Enum.into(Heap.new(fn {d1, _, _}, {d2, _, _} -> d1 < d2 end))

    a_star_help(queue, target, max_d, %{}, neighbors_fn)
  end

  def a_star_help(queue, target, max_d, visited, n_fn) do
    # Util.inspect(queue |> Enum.into([]))

    cond do
      Heap.empty?(queue) -> nil
      true -> a_star_help2(queue, target, max_d, visited, n_fn)
    end
  end

  def a_star_help2(queue, target, max_d, visited, n_fn) do
    {head, rest} = Heap.split(queue)
    {d, prev, v} = head
    # Util.inspect(d, v)
    prev_cost = Map.get(visited, v)

    cond do
      d > max_d ->
        []

      prev_cost != nil and d > prev_cost ->
        a_star_help(rest, target, max_d, visited, n_fn)

      target.(v) ->
        # TODO: not strictly correct, this should really do all
        # the work in the true branch, too. But this is valid if
        # We only want the paths that are _exactly_ d distance.
        [
          {d, Search.reconstruct_path(v, prev)}
          | a_star_help(rest, target, max_d, visited, n_fn)
        ]

      true ->
        nexts = n_fn.(v)
        # IO.inspect(nexts)
        d_nexts = nexts |> Enum.map(fn {nd, nv} -> {d + nd, head, nv} end)
        # IO.inspect(d_nexts)
        next_queue = d_nexts |> Enum.reduce(rest, fn next, h -> Heap.push(h, next) end)
        # IO.puts("next heap")
        # Util.inspect(next_queue |> Enum.into([]))
        next_visited = Map.put(visited, v, d)
        a_star_help(next_queue, target, max_d, next_visited, n_fn)
    end
  end
end
