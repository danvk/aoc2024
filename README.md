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
- `Enum.with_index` is like Python's `enumerate`. It's like `Enum.map` but with an index parameter. Annoyingly, it keeps the index in the return type.
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

I'm playing around with type hints for day 6 and am… disappointed. After writing a bunch of typespecs, I still get no quickinfo beyond "variable" when I inspect a function parameter. I'm also not getting type errors in the editor.

I feel like I'm missing something. Are `@spec` and `@type` checked in any way? https://elixirschool.com/en/lessons/advanced/typespec indicates that they're mostly for documentation, but https://hexdocs.pm/elixir/typespecs.html#functions-which-raise-an-error indicates that Dialyzer can check them. This article has some advice: https://fly.io/phoenix-files/adding-dialyzer-without-the-pain/

Running `mix dialyzer` I get:

    Total errors: 0, Skipped: 0, Unnecessary Skips: 0

which seems wrong since I deliberately introduced a type error. If I make a very simple type error (returning string instead of integer) then I do get a warning in VS Code via Dialyzer. But I see no improvements in quickinfo. If this is true, I think it's something Elixir can learn from TS: types are about the full DX, not just catching errors. This was a mistake that Closure Compiler made.

## Day 8

Pretty easy today. My one hiccup was that I needed _two_ `flat_map`s, one to flatten across frequencies and one to flatten across pairs of spots. I thought about iterating until I was out-of-bounds on part 2, but didn't bother. I just construct `max(w, h)` points in either direction from each pair and filter to what's out of bounds. Very inefficient, but trivially correct and fast enough for today.

## Day 9

Oh man would this be easier with an array.

Interesting that a default value for a parameter can't refer to previous parameters.

```elixir
def repeat(x, n) do
    for _ <- 1..n, do: x
end

>>> repeat(nil, 0)
[nil, nil]
```

Why isn't a `do..end` block allowed after a `->` in a `case`? I guess you don't need it, it's fine to put multiple statements in there.

In Elixir, `None > 0`.

Well that was brutal. I think today was uniquely poorly-suited to Elixir. It's way easier with an array and mutation. That being said, there were other problems, too. I got wrong answers for both parts. In part 1, the problem was Elixir's odd treatment of ranges: 1..0 is a non-empty range equal to [1, 0]. That is… strange. This wasn't a part of my code that I expected to break, so I didn't unit test it.

My code worked on the sample input, so I was kind of at a loss. To debug, I implemented a solution in Python, confirmed that it was correct by getting my star, and then checked its output vs. my Elixir code on prefixes of the input. 20 chars was enough to get a difference.

For part two, I switched to using a Map. I think I set this up backwards from what would be useful (range -> value) instead of (value -> range), but whatever. I got a correct answer on the sample input, but again, I got a wrong answer on my own input. I looked for off-by-one errors but didn't find any.

So once again, I re-implemented a solution in Python. Part 2 was much more challenging and a lot slower, but a brute force solution still worked and showed the difference. I had a bug in my Python code: I'd find the lowest gap and swap into it, but you only want to do that if the gap is before the span that you're considering. It turned out that my Elixir code had the same bug (it must have been slightly more subtle since I got the right answer on the sample input). Fixing it got me the correct answer (and it's faster than Python!).

So lesson: be really wary of Elixir ranges?

## Day 10

Not too bad today, just construct a graph and do a BFS. For part 2, I changed my `visited` set to a map from position -> number of times I visited that node.

A few Elixir notes for the day:

- ~You can't do `nil or 0` in Elixir.~ You do `nil || 0` instead.
  - https://stackoverflow.com/q/34605325/388951
  - `or` and `and` require a boolean, `||` and `&&` do not.
  - `or` and `and` short-circuit, `||` and `&&` do not.
- A `MapSet` is Elixir's version of a set.
- `Map.get_and_update` lets you retrieve the current value and fill in a new value for a map in one pass, but it has a really weird contract. It requires you to return a pair with the current value and the new value. Huh? Why does it need to old value? Another surprise: it returns a tuple with the new value and the map, not just the map. Maybe I should just write a wrapper for this.

I'm going to try installing Elixir 1.18, which hit RC today. It has significant improvements to "set-theoretic types" and language services. It's on the `v1.18.0-rc.0` branch, but unclear to me how to install this with homebrew. Instead, I'm using

    brew unlink elixir
    brew install --HEAD elixir

No new type errors, no obvious difference in language service.

## Day 11

This was a fun one. I had about 25 minutes between breakfast and our departure for a hike (Sendero Pre-Hispánico). I did manage to get both stars, but it was a nail-biter!

Part 1 was straightforward. Part 2 obviously wasn't going to work. My first instinct was to fit a curve to the number of stones per blink. It's very close to an exponential, but not exactly. I thought it might be some kind of Fibonacci-like sequence, but I wasn't going to get that to work quickly enough.

I decided to give up and quickly wrote down some ideas for what to do next in this doc. My second idea was to track just the count for each number, since the position of the stones doesn't matter. Wait, that might just work! I raced furiously to code it up and got my second star just as we had to leave.

I did not notice any difference from the new version of Elixir today, so I'm not entirely confident I have it set up correctly.

## Day 12

Today was a bit of a strugglefest. I spent most of the time for part 1 writing code to relabel the grid so that all components were contiguous. This was harder than I expected -- you can't just iterate over the grid, you really need a DFS. Otherwise you risk splitting components in half.

For part 2 I checked if the next segment clockwise was a fence segment of the same type. It's a little ugly but it worked!

The lack of type checking really is a disaster for Elixir. I'm constantly making type errors with enum methods on maps.

```
- Map.get(grid, x, y)
+ Map.get(grid, {x, y})
```

Discussion on RC's #elixir suggests this may never be a thing type checking can help with. So maybe the better solution for me is to make a `Grid` module with stricter methods.

## Day 13

First thought: A*, priority search! Second thought: you only need to scan in one dimension since the number of A presses uniquely determines the number of B presses. It's like a line with a bend. Upon seeing part 2: oh wait, this really is just a system of equations. And fortunately none of the inputs have A & B parallel to each other, which would be a _much_ harder problem.

Since we didn't have internet at Rio Claro, or in the room at El Paujil, this is reminding me a lot of 2019's AoC, where I was always catching up.

I want to be able to pattern match on strings to extract numbers, e.g. `"a=#{a}" = txt`.

The Elixir language service is constantly crashing without internet. It's complaining about Elixir 1.19 not being supported. Since I'm getting no value out of the new version, I should probably downgrade when I get better wifi.

## Day 14

You can write `String.slice(2..-1//1)` to read until the end of the string.

Part 1 is (hopefully) not too bad. I assume part 2 will ask us to do a trillion steps, in which case my guess is that this all repeats after 103*101 steps. Or if not, then at least each individual robot will repeat with some cycle.

… wow was that ever not what I expected. Things I tried:

- Symmetric (according to quadrants) -- too many
- Symmetric (truly) -- none
- Look at first 100 -- nope
- Look for states where an unusual number of robots have neighbors. Bingo!

## Day 15

Part 1: (hopefully) not as bad as I'd thought, shoving is just a matter of finding the next open square in that direction and swapping two cells.

I honestly have no clue what part 2 will be. Iterate a lot longer? Do it with several robots? One of the moves spawns a new robot? There's gravity?

It's kind of Eric to put a boundary wall around his grids. It means you don't need any bounds checking.

OK, that was definitely not what I was expecting! I think this is just going to be annoying. My swapping trick won't work. Instead, I need two recursive functions: one to check if shoving is feasible, and one to actually do it.

… I'm actually reasonably happy with this solution. My one significant bug not setting the old location of a block to `.` after you shoved it. Printing the grid on every step helped debug this.

There's no way to do either/or matches in Elixir:
https://stackoverflow.com/q/39139814/388951

## Day 16

I copy/pasted the text from the problem page that I'd loaded on my phone. This works surprisingly well!

I don't think Elixir has a built-in Heap module, which will make implementing A* hard.

I don't think I like putting destructuring patterns in function signatures. It feels like it exposes some of the implementation and prevents you from giving the parameters meaningful names.

A* search always feels like a bit of a miracle when it works. But after many years of AoC, I feel pretty confident about implementing it!

Part 2: I need to modify the search in three ways:

1. To return paths
2. To consider all optimal paths
3. To not prune identical-scoring paths to the same state.

I think I'll make it unconditionally return paths. Then maybe I'll have a variation that returns all paths to the target with a given length. I'm not sure how to implement the third one. Maybe I can't prune at all?

OK, in retrospect I must prune. But I can prune only if the previous distance is strictly less than the current distance. Part 2 didn't wind up being as bad as I'd feared, though I did have to copy/paste `search.ex` for the day 16 variation, which is kinda gross.

## Day 17

This seems tedious to implement. Probably a good first opportunity to use an Elixir struct.

There are a lot of silly, annoying things in Elixir's VS Code setup. For example, typing a ":" anywhere in a comment autocompletes to ":application". If you end a line with a ":" (as I often do!) then you'll hit enter and accept the autocomplete.

Defining a struct feels pretty funny without types. You just specify the field names. I wrote `ip: integer` without even thinking about it.

Early exit is not a thing, they recommend helper functions:
https://elixirforum.com/t/how-to-return-or-break-from-an-action-early/20904/4

This is something I've observed, too. And I don't like it.

Elixir LSP crashloops if there are any errors when you start it.

"No such function foo/2 exists" feels like a misleading message when you've just passed the wrong number of arguments.

Only the last six bits of A affect the next output.
4 and 6 have unique last six bits that produce them.
There are two 4s and one 6 in the input.

… I couldn't get that to work. Instead I implemented the machine encoded by my input in Python, then did brute force search digit-by-digit. I don't think you can do one digit at a time since the last six digits matter. So I tried 8*8 possibilities and then allowed the top oct to vary on the next round.

## Day 18

Easy application of search. I expected part 2 to be a time-based search (position X, Y becomes blocked at time T). This seems easier.

For part 2, I did a manual binary search, then a linear search.

## Day 19

Part 1: I'll create a graph of allowed letter transitions. Wait, isn't that how grep works? Uh, this is just grep?

Of course that won't work for part 2. My first thought was that I might need to create the graph. But then I had a better thought: dynamic programming from the end of the string. For the last N characters, try matching each pattern against the start. Then you already know the number of ways to make the rest.

I wound up implementing this in Python, but I'll go back and port it to Elixir later.

## Day 20

My first thought was to add `hasCheated` to the search state, but that's not quite what you want since we're not just looking for the optimal cheat. I'd need to adapt my Day 16 search to really have a `maxDistance` option.

Second thought is to try adding cheats to each `#` adjacent to the optimal path and re-run the plain-vanilla shortest path search for each. I think you can only go through a single `#`, not `##`. Interestingly there are no walls with a width of exactly two. So I guess he specifically doesn't want to consider this case.

I think these are equivalent but I don't really understand why:

```elixir
defp parse_line(line), do: String.split(line)

defp parse_line(line) do
    String.split(line)
end
```

Second thought worked great. Took ~1 minute to run, trying 9336 candidate cheats. An optimization might be to not reconstruct the path for the second pass (where you only care about distance).

Part 2: now the ambiguity in the question is more front-and-center. He never shows a cheat passing over open track and back into a wall, but I don't see why you couldn't do that. I think I do want to go back to my first thought.

I think the A* search will be too slow for part 2. I need a different approach.

I can calculate the (non-cheating) distance from the finish to every open square.
Then, for every cheat_start (9336 candidates), look at all the cheat_ends within d=20 (~200). This will form a diamond pattern. For each of these, check:

1. Does it save enough distance?
2. Is there a neighboring `#` within d=19 of the cheat_start?

This should be very fast.

… this is surprisingly annoying to implement. The "cheat start" for uniqueness purposes is the position _before_ the first wall, not the position of the first wall.

Also, with max_cheat=20, the first wall you bust through might not be adjacent to the shortest non-cheaty path. I need to consider _all_ walls.

On second thought, I may have completely made up the constraint that the cheat ends immediately after going onto a `.` square.

Do I need to consider non-optimal paths between cheat_start and cheat_end? I don't think so, the phrasing is "this cheat saves X picosecond," which to me implies optimality.

"Each cheat has a distinct start position (the position where the cheat is activated, just before the first move that is allowed to go through walls)" -> this implies to me that a cheat must start just before you move onto a `#`.

Ah, maybe I'm not allowing you to cheat via the outer perimeter?
That was definitely a part of it. The other part was that cheats don't need to start right before you cross a wall. They can start anywhere. So the quote about "just before the first move" was extremely misleading.

I found today's puzzle super frustrating. The most frustrating so far. Mostly because part 2 was so contrived and ambiguous.

You _can_ use a `when` clause in a comprehension, it just doesn't go where I expected:

```elixir
for x when x >= 0 <- [1, -2, 3, -4], do: x
```

## Day 21

My assumptions are:

1. It's not computationally feasible to treat this all as one big search problem.
2. You need to take _an_ optimal path through the numeric keypad. Presumably there's a reason the problem mentions (and shows) the three optimal paths.
3. It probably doesn't matter how you handle the directional keypads since you keep having to go back to the "A" button.

Typing out explicit types in Elixir might actually be really annoying in practice since it pushes you to write so many tiny, external helper functions.

It seems that the sequence of dirpad presses _does_ matter, ever so slightly. I have to keep a pool of all the shortest sequences, I can't just pick one. This makes the problem blow up. For `029A` after the first robot, I have 128 optimal sequences. After the second, I have 589824 optimal sequences.

It might be interesting to see exactly why picking one shortest dirpad sequence doesn't give the optimal result. This only seems to be an issue with 2+ robot dirpads in the middle. For `029A`, I get a sequence with length 70 instead of 68.

This is the difference between the optimal and non-optimal sequences:

```
- ~c"v<<A>>^A<A>AvA<^AA>A<vAAA>^A"
+ ~c"<v<A>>^A<A>AvA<^AA>A<vAAA>^A"
```

Since you start on `A`, the bad one travels a greater distance from `A`->`<` unnecessarily.
I can calculate this cost cheaply and sort by it.

I'm _still_ blowing up. The next culprit was `dir_for_dir`, which calculates all direction sequences for a direction sequences. Throwing a `min_by` there lets me run instantly up to ~n=5. I'm still blowing up somewhere, though.

All places where I'm generating a list of sequences are suspect. There's also just some blowup in the sequence itself. Each sequence is ~2.5x the length of the previous one. So even storing the full sequence is too much. (It would be ~100B key presses.)

Maybe I can do memoization / dynamic programming on `(dirkey1, dirkey2, depth)`.
Or that won't quite work. It'll still blow up. But it does feel like there's some recurrence relation I can find here.

cost(dirkey1, dirkey2, depth) = best path from dirkey1 -> dirkey2 * cost of each transition at depth-1.

That was basically right. It just took a lot of fiddling to get the costs perfectly correct.

## Day 22

This felt way too easy for day 22. After foibles the last few days, I moved very deliberately through the examples, making sure I didn't have any off-by-ones. Searching through the "quads" was too slow for my input, but making an index from quad -> price resolved that. I just do brute force search across `(-9..9)*4` and, after a few hundred million map lookups, I have my answer.

I did get a wrong answer for part 2 -- the example shows 10 secrets _including_ the initial secret, but then the problem asks for 2000 secrets _after_ the initial secret. Fortunately this was not too hard to spot.

Ryan pointed out a big speedup: you can merge the indexes and take the max value across them. Doing this sped up part 2 from ~45s -> ~4.5s. I guess there are a lot of "quads" that never occur.

This is an interesting example of typing going differently than in TS:

```elixir
def get_tail(list), do: tl(list)

def main(input_file) do
  IO.puts(get_tail(1..10))
end
```

I get this error on the `IO.puts` line:

```
The function call will not succeed.

Day22.get_tail(%Range{:first => 1, :last => 10, :step => 1})

will never return since the 1st arguments differ
from the success typing arguments:

(nonempty_maybe_improper_list())
```

This comes from Dialyzer, not the new type checker. TS would make you put a type signature on `get_tail`, which would force the error to be either in the caller or the implementation.

## Day 23

2376 is too high.

## Things to try in Elixir before this is done

- Learn about macros.
- Read the PDF about the type system.
- Write a unit test

## Misc Elixir notes

Parentheses are optional around function calls:

```elixir
> xs = [1, 2, 3]
> Enum.sum(xs)
6
> Enum.sum xs
6
```

Elixir makes a big deal of its built-in constructs being possible to implement in the language itself, and I guess this is part of what makes that work. For example:

```elixir
iex(4)> quote do
...(4)>   for x <- xs, x * x
...(4)> end
{:for, [],
 [
   {:<-, [], [{:x, [], Elixir}, {:xs, [], Elixir}]},
   {:*, [context: Elixir, imports: [{2, Kernel}]],
    [{:x, [], Elixir}, {:x, [], Elixir}]}
 ]}
```

Can `|>` be implemented via a macro?

```elixir
iex(1)> quote do
...(1)>   [1, 2, 3] |> Enum.sum()
...(1)> end
{:|>, [context: Elixir, imports: [{2, Kernel}]],
 [
   [1, 2, 3],
   {{:., [], [{:__aliases__, [alias: false], [:Enum]}, :sum]}, [], []}
 ]}
 ```

I think it is:
https://github.com/elixir-lang/elixir/blob/v1.18.0/lib/elixir/lib/kernel.ex#L4357

This is an interesting example of a macro for `regex_case`:
https://stackoverflow.com/a/34692927/388951
