#!/usr/bin/env python

import sys


def expand(xs):
    disk = []
    i = 0
    is_used = True
    for x in xs:
        if is_used:
            disk += ([i] * x)
            i += 1
        else:
            disk += ([None] * x)
        is_used = not is_used
    return disk


def compact(xs):
    xs = [*xs]
    i = 0
    j = len(xs) - 1
    while i < j:
        f = xs[i]
        b = xs[j]
        if f is not None:
            i += 1
        elif b is None:
            j -= 1
        else:
            xs[i] = b
            xs[j] = f
            i += 1
            j -= 1

    return xs


def checksum(xs):
    return sum(x * i for i, x in enumerate(xs) if x is not None)


def main():
    (input_file,) = sys.argv[1:]
    content = open(input_file).read().strip()
    nums = [int(x) for x in content]
    disk = expand(nums)
    print(disk)
    compacted = compact(disk)
    print(compacted)
    print(checksum(compacted))


if __name__ == '__main__':
    main()
