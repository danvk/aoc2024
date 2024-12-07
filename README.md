# Advent of Code 2024

Compile and run code for a day with:

    mix escript.build && ./main 4 input/day4/sample2.txt

## Day 1 (40886 / 37736)

Quite easy, interesting that the problem isn't entirely line-oriented. I can't imagine an LLM would have any trouble with the problem today.

After working through the first three days of the 2016 Advent of Code in Elixir, setup was no problem today. I can tell that pipes, the various `Enum` methods and `Map`s are going to be critical. I'm also wondering if this is going to be a strange introduction to Elixir. The AoC problems are all short-running, single-threaded, one-off scripts. My sense is that Elixir is better known as a language for long-running, concurrent processes.

## Day 2

I raced to get this done in the 15 minutes I had before Spanish class. The trick was getting an index, which most Elixir methods don't want to give you. I wound up using `Enum.zip` with `1..Enum.count(xs)`. No idea if this is idiomatic, but it works. For part 2, I implemented a drop function and tried all drops.

## Day 3

Downloaded the puzzle via personal hot spot before our plane took off for Cali but didn't have time or energy (it was 4 AM!) to work on it before we left. The plane doesn't seem to have wifi so I can't submit ☹️

First time using a regular expression. It's `~r//`, not a string. I guess that's a "raw charlist?"

I'm starting to think that, from a JS/TS perspective, the most interesting thing I'm going to learn about Elixir is how it handles pipelines, generators and anonymous functions. For example:

```elixir
nums |> Enum.sum()
```

This feels natural, but it's actually pretty weird! `Enum.sum/1` takes one argument, but you're calling it with none. How does that work? I assume it's something to do with macros.

Lots of my pipeline expressions have been of the form:

```elixir
list
|> Enum.map(fn1)
|> Enum.map(fn2)
...
```

I assume this can be written more concisely (without all the `Enum.map` calls) using generators.

## Day 4

Totally missed that the XMAS could be _diagonal_ on part 1.
This is the first day involving a grid, Again, storing grids as a map from `{x, y}` tuples to characters is usually the way to go.
Elixir's way of representing strings (linked list of chars) worked well today since it was easy to throw `nil` into a string. `[?X, ?M, nil, nil]` works just fine and is not `== ?c"XMAS"`.

I'm using more comprehensions and fewer pipeline operations. Comprehensions are a convenient way to flatten as well as map. I'm thinking that the angle for my eventual blog post will be "what Elixir can teach JS about the pipeline operator proposal." Pipelines make you want more compact ways to define functions, but maybe they really make you want comprehensions.

Elixir ranges are inclusive on both ends: `x <- 0..w` will include `x=w`. This is pretty unusual!

The Elixir docs say that charlists are rare and mostly for Erlang compatibility, so maybe I'm overusing them.

## Day 5

Part 1 was fiddly and annoying. I missed the "ignore all rules mentioning a number not in the input." Part 2 was a head scratcher for a moment, until I realized you could sort by the number of required predecessors. I guess there's no transitivity in these rules? This could have been harder!

## Day 6

How do you write one char to stdout?
Does Elixir have a `Set` type?
GitHub copilot is mega-unhelpful here, giving me recursive `loop` constructs that don't work.

`Map.put(map, key, value)` is very different than `map.put(key, value)`.

I could have really used some type help to keep positions and values distinct.

I keep finding it annoying that you can't put multiple statements inside a comprehension.

Jeremy reported having to do some optimizations to make part 2 finish in a reasonable amount of time. I did run in optimized mode, and it took ~20s to complete. So I guess I am benefiting from Elixir/Erlang's speed, at least relative to Python.

Jeremy also pointed out that I only needed to consider the locations visited in part 1 when solving part 2. Of course! After implementing that optimization, my code only takes ~4s to solve both parts.

This looks extremely helpful: https://hexdocs.pm/elixir/enum-cheat.html

- There's a `:reduce` option with comprehensions.
- Use `Enum.member?` to test for membership, or equivalently `item in enum`. (Presumably this is always O(N).)
- `string =~ part` checks if `part` is part of `string`. (It also applies a regex, just like Perl.)
- `Enum.map_reduce` lets you map and reduce simultaneously, resulting in a pair.
- `Enum.scan` is equivalent to my `accumulate` helper: like `reduce`, but returns a list with the accumulator value at every item.
- `Enum.frequencies` gives you a frequency Map.
- `Enum.into` converts an enum into a "collectable."
- `Enum.to_list` does what you'd expect.
- `Enum.uniq` de-dupes an entire collection, while `Enum.dedupe` only dedupes contiguous elements.
- `Enum.with_index` produces a `value -> index` Map.
- `Enum.with_index` is like Python's `enumerate`. It's like `Enum.map` but with an index parameter.
- `Enum.slide` moves an element or range to a new index.
- `Enum.chunk_by` splits an enumerable every time a function returns a new value.
- `Enum.unzip` converts a list of tuples to a tuple of lists.

https://hexdocs.pm/elixir/gradual-set-theoretic-types.html#supported-types

- Types are currently not very fine-grained (`tuple()` is an indivisible type) but they plan to change this after getting feedback on the quality of type errors.
- Types are "set-theoretic" in that you can write `A or B` and `A and B`.
- There's also a `not()` construct, which is unliked anything in TypeScript: `atom() and not (:foo or :bar)`.
- The top type is `term()`. The bottom type is `none()`.
- Typing is gradual via `dynamic()`. This is distinct from `any` in that you can write something like `dynamic(atom() or integer())` and you'll be allowed to call functions that accept `atom()` or `integer()` but not `string()`. I think Pyright does something like this, too.

Use can use `with` to do a series of pattern matches.

## Day 7

Max of 12, not so bad.

Part 1: Left to right, they said! I reversed all the inputs to get that to work.

Part 2: Of course, after part 2, I had the `concat` call backwards.

Today was pretty easy. I guess I could have sped it up by only considering the instructions that failed part 1 for part 2, but the whole thing ran in only 9s.
