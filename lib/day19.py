import fileinput


def num_ways(line, pats):
    # Strategy: dynamic programmming.
    # For each N, count the ways to form line[-N:]
    ways = [1]
    for i in range(1, len(line)+1):
        target = line[-i:]
        this_ways = 0
        for pat in pats:
            if target.startswith(pat):
                w = ways[i - len(pat)]
                this_ways += w
        ways.append(this_ways)
        # print(ways)
    return ways[-1]


def main():
    lines = [line.strip() for line in fileinput.input()]
    pats = lines.pop(0).split(', ')
    assert lines.pop(0) == ''
    num_total = 0
    num_possible = 0
    for line in lines:
        ways = num_ways(line, pats)
        num_total += ways
        if ways > 0:
            num_possible += 1
    print(num_possible)
    print(num_total)


if __name__ == '__main__':
    main()
