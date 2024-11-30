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

## Day 2

972899 is too high.
Problem was a trailing newline, which made me repeat the last entry.

TODO:

- [x] Fix the trailing newline bug
- [x] Make accumulate more efficient
- [x] Move accumulate into a library file
- [x] Make it work for both parts

I noticed `itertools.accumulate` recently and decided that was the function I wanted on day 1. Easy enough to implement.

Module constants in Elixir seem pretty weird. They're prefixed with `@`.

You match a character with `?A`, `?B`, etc.

I think GitHub copilot is familiar with previous year's Advent of Code, the autocomplete is rather surprisingly good.

I'm surprised how much ceremony there is to pass a function around in Elixir. `&Day2.apply_instrs/2` instead of just `apply_instrs`. I guess the `/2` helps with resolution, but why the `&`?

`&Day2.apply_instrs(&1, &2, 2)`: Is there shorthand for binding just the first or last argument of a function?

To move code into a `Common` module, I had to put it in `lib/common.ex` (not `lib/common.exs`) and compile it with `elixirc`:

    elixirc lib/common.ex

So now I have a build step.

It may be possible to use `Mix.install` instead: https://stackoverflow.com/a/75425548/388951

Language services are pretty crappy -- I'm not getting syntax errors, F2 rename variable or any type information. Unclear to me if this is expected or some kind of configuration error.

## Day 3

Not too bad. Part 2 was an annoying rearrangement of the input that makes it not purely line-oriented. Fortunately Elixir has `Enum.chunk` built-in.

You write the identify function `&(&1)`.

My `transpose` function is inefficient but simple. Generators are going to be handy. I thought I had a bug at first, but `IO.puts` renders `[100, 101, 102]` as a charlist, `~c"efg"`.

I continue to be puzzled that I don't get any kind of syntax guidance in VS Code. Aha! It seems to be a `.ex` vs. `.exs` difference.

https://elixirforum.com/t/vscode-elixirls-not-highlighting-exs-files/40239
https://github.com/elixir-lsp/elixir-ls/issues/89

Now I'm getting errors… but weird ones. It seems like the language service is actually running my code?

```
$ elixirc lib/day3.ex

== Compilation error in file lib/day3.ex ==
** (RuntimeError) Usage: day3.ex <input_file>
    lib/day3.ex:21: Day3.get_arg1/0
    lib/day3.ex:26: (file)
    (elixir 1.17.3) lib/kernel/parallel_compiler.ex:429: anonymous fn/5 in Kernel.ParallelCompiler.spawn_workers/8
```

https://elixirschool.com/en/lessons/intermediate/escripts

Aha again! All code must be inside `defmodule`. Now I get lots more information in my editor like `@spec` annotations on my functions. It looks like you can click these to fill in type annotations.

I'm able to run my script wiht `escript` using this sequence:

    mix escript.build
    ./day3 input/day3/input.txt

I don't love this, but I can work with it. It might be a good idea to look into how someone from r/adventofcode sets up their Elixir project.

https://github.com/mathsaey/adventofcode
https://github.com/mathsaey/advent_of_code_utils

He runs his code through `iex`.
