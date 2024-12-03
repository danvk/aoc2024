# Advent of Code 2024

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
