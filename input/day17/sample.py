for i in range(0, 63):
    A = 0x2102F50
    # 2, 16, 47, 80
    # A = 80 + 256 * (47 + 256 * (16 + 256 * 2))
    # only A is carried between iterations of the loop
    # only the last six bytes of A affect each output
    out = []
    while True:
        # print(f'A={bin(A)}')
        B = A % 8  # B = last byte of A; 0 < B < 8
        B = B ^ 5  # xor B with 5; 0 < B < 8
        C = A // 2**B  # drop 0-7 bits of A to get C
        # print(f'{C=}')
        B = B ^ 6  # xor B with 6; 0 < B < 8
        B = B ^ C
        # print(f'{B=}')
        print(B % 8)
        A = A // 8  # drop last three bits of A
        if A == 0:
            break
