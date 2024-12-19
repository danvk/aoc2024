def get_output(A):
    out = []
    while A > 0:
        # 2, 16, 47, 80
        # A = 80 + 256 * (47 + 256 * (16 + 256 * 2))
        # only A is carried between iterations of the loop
        # only the last six bytes of A affect each output

        # print(f'A={bin(A)}')
        B = A % 8  # B = last byte of A; 0 < B < 8
        B = B ^ 5  # xor B with 5; 0 < B < 8
        C = A // 2**B  # drop 0-7 bits of A to get C
        # print(f'{C=}')
        B = B ^ 6  # xor B with 6; 0 < B < 8
        B = B ^ C
        # print(f'{B=}')
        out.append(B % 8)
        A = A // 8  # drop last three bits of A

    return out


A = 0x2102F50
A = 0b001110  # 4
A = 0b011110  # 6

target = [2,4,1,5,7,5,1,6,0,3,4,3,5,5,3,0]

candidates = []
for A in range(0, 8 ** 5):
    out = get_output(A)
    # print(bin(A), '->', out)
    if out[0:3] == target[0:3]:
        # print(f'{oct(A)}', '->', out)
        candidates.append(A)

print(f'N=3 {len(candidates)=}')

for N in range(4, len(target)):
    # Treat the last N-1 octs as fixed.
    # Try all 64 of the next 2 octs.
    next_candidates = set()
    this_target = target[0:N]
    m = 8 ** N
    m2 = 8 * m
    for i in range(0, 64):
        for cand in candidates:
            base = cand % m
            A = i * m + cand
            out = get_output(A)
            if out[0:N] == target[0:N]:
                next_candidates.add(A)

    print(f'{N=} {len(next_candidates)=}')
    candidates = next_candidates

correct_candidates = [
    c for c in candidates
    if get_output(c) == target
]

print(len(correct_candidates))
print(min(correct_candidates))

# print(get_output(0b001100001))
# print(get_output(0b011110000))
# print(get_output(0b011011))

