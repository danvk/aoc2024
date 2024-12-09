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


def compact2(xs: list[int|None]):
    m = max(x for x in xs if x is not None)
    xs = [*xs]
    print(m)
    while m >= 0:
        if m % 100 == 0:
            print(m)
        idxs = [i for i, x in enumerate(xs) if x == m]
        if not idxs:
            continue
        a, b = min(idxs), max(idxs)
        span = b - a + 1
        # print(m, a, b)
        for i, v in enumerate(xs[:a]):
            if v is not None:
                continue
            if i + span >= len(xs):
                break
            is_ok = True
            for j in range(i + 1, i + span):
                if xs[j] is not None:
                    is_ok = False
                    break
            if not is_ok:
                continue

            # print(m, a, b, '->', i, i+span)
            for j in range(i, i + span):
                xs[j] = m
            for j in range(a, b + 1):
                xs[j] = None
            break
        m -= 1
    return xs


def main():
    (input_file,) = sys.argv[1:]
    content = open(input_file).read().strip()
    nums = [int(x) for x in content]
    disk = expand(nums)
    # print(disk)
    compacted = compact(disk)
    # print(compacted)
    print(checksum(compacted))
    compacted = compact2(disk)
    # print(compacted)
    print(checksum(compacted))


if __name__ == '__main__':
    main()
