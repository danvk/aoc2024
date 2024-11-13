# Advent of Code 2016

## Day 1

Setup was not difficult, `brew install elixir`.

It's convenient that Elixir has a scripting mode (`.exs`).
I installed the Elixir VS Code extension, but I'm not getting much from it. I think it requires a "mixfile" to understand my project.
I had the logic wrong on part 1 (walk then turn, not turn then walk), but still got the correct answer. Unclear whether that would have worked for part 2.

I don't love my solution to part 2. The nested `Enum.reduce_while` calls feel icky. I wonder if a more idiomatic way to do this would be with processes, to have one process send a message for each location you visit and the other wait for a repeat.

It's annoying that you can't interpolate an `{int, int}` tuple into a string:

```
iex(6)> tup = {1, 2}
{1, 2}
iex(7)> "hello #{tup}"
** (Protocol.UndefinedError) protocol String.Chars not implemented for {1, 2} of type Tuple
    (elixir 1.17.3) lib/string/chars.ex:3: String.Chars.impl_for!/1
    (elixir 1.17.3) lib/string/chars.ex:22: String.Chars.to_string/1
    iex:7: (file)
```

This is especially annoying since the syntax for indexing into tuples is so verbose (`elem(tup, 1)`).

All the pairs and triples you wind up forming for calls to reduce make me want a type system.
