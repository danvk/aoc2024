defmodule Search do
  def a_star(starts, target, neighbors_fn) do
    # The heap contains {distance, prev tuple, state} tuples.
    queue =
      starts
      |> Enum.map(fn start -> {0, nil, start} end)
      |> Enum.into(Heap.new(fn {d1, _, _}, {d2, _, _} -> d1 < d2 end))

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
    {head, rest} = Heap.split(queue)
    {d, prev, v} = head
    # Util.inspect(d, v)
    prev_cost = Map.get(visited, v)

    cond do
      target.(v) ->
        {d, reconstruct_path(v, prev)}

      prev_cost != nil and d > prev_cost ->
        a_star_help(rest, target, visited, n_fn)

      true ->
        nexts = n_fn.(v)
        # IO.inspect(nexts)
        d_nexts = nexts |> Enum.map(fn {nd, nv} -> {d + nd, head, nv} end)
        # IO.inspect(d_nexts)
        next_queue = d_nexts |> Enum.reduce(rest, fn next, h -> Heap.push(h, next) end)
        # IO.puts("next heap")
        # Util.inspect(next_queue |> Enum.into([]))
        next_visited = Map.put(visited, v, d)
        a_star_help(next_queue, target, next_visited, n_fn)
    end
  end

  def reconstruct_path(state, nil) do
    [state]
  end

  def reconstruct_path(state, prev) do
    {_, prev_prev, prev_state} = prev
    [state] ++ reconstruct_path(prev_state, prev_prev)
  end

  def flood_fill(starts, neighbors_fn) do
    # The heap contains {distance, state} tuples.
    queue =
      starts
      |> Enum.map(fn start -> {0, start} end)
      |> Enum.into(Heap.new(fn {d1, _}, {d2, _} -> d1 < d2 end))

    flood_fill_help(queue, %{}, neighbors_fn)
  end

  def flood_fill_help(queue, visited, n_fn) do
    cond do
      Heap.empty?(queue) -> visited
      true -> flood_fill_help2(queue, visited, n_fn)
    end
  end

  def flood_fill_help2(queue, visited, n_fn) do
    {head, rest} = Heap.split(queue)
    {d, v} = head
    prev_cost = Map.get(visited, v)

    cond do
      prev_cost != nil and d > prev_cost ->
        flood_fill_help(rest, visited, n_fn)

      true ->
        nexts = n_fn.(v)
        d_nexts = nexts |> Enum.map(fn {nd, nv} -> {d + nd, nv} end)
        next_queue = d_nexts |> Enum.reduce(rest, fn next, h -> Heap.push(h, next) end)
        next_visited = Map.put(visited, v, d)
        flood_fill_help(next_queue, next_visited, n_fn)
    end
  end
end
