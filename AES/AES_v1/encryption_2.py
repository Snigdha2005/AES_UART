Nk = 4  # Number of 32-bit words in the key (can be 4, 6, or 8 for AES)
Nb = 4  # Number of 32-bit words in the state (always 4 for AES)
Nr = 10
Rcon = [
    0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80,
    0x1B, 0x36
]
s_box = [
    [0x63, 0x7C, 0x77, 0x7B, 0xF2, 0x6B, 0x6F, 0xC5, 0x30, 0x01, 0x67, 0x2B, 0xFE, 0xD7, 0xAB, 0x76],
    [0xCA, 0x82, 0xC9, 0x7D, 0xFA, 0x59, 0x47, 0xF0, 0xAD, 0xD4, 0xA2, 0xAF, 0x9C, 0xA4, 0x72, 0xC0],
    [0xB7, 0xFD, 0x93, 0x26, 0x36, 0x3F, 0xF7, 0xCC, 0x34, 0xA5, 0xE5, 0xF1, 0x71, 0xD8, 0x31, 0x15],
    [0x04, 0xC7, 0x23, 0xC3, 0x18, 0x96, 0x05, 0x9A, 0x07, 0x12, 0x80, 0xE2, 0xEB, 0x27, 0xB2, 0x75],
    [0x09, 0x83, 0x2C, 0x1A, 0x1B, 0x6E, 0x5A, 0xA0, 0x52, 0x3B, 0xD6, 0xB3, 0x29, 0xE3, 0x2F, 0x84],
    [0x53, 0xD1, 0x00, 0xED, 0x20, 0xFC, 0xB1, 0x5B, 0x6A, 0xCB, 0xBE, 0x39, 0x4A, 0x4C, 0x58, 0xCF],
    [0xD0, 0xEF, 0xAA, 0xFB, 0x43, 0x4D, 0x33, 0x85, 0x45, 0xF9, 0x02, 0x7F, 0x50, 0x3C, 0x9F, 0xA8],
    [0x51, 0xA3, 0x40, 0x8F, 0x92, 0x9D, 0x38, 0xF5, 0xBC, 0xB6, 0xDA, 0x21, 0x10, 0xFF, 0xF3, 0xD2],
    [0xCD, 0x0C, 0x13, 0xEC, 0x5F, 0x97, 0x44, 0x17, 0xC4, 0xA7, 0x7E, 0x3D, 0x64, 0x5D, 0x19, 0x73],
    [0x60, 0x81, 0x4F, 0xDC, 0x22, 0x2A, 0x90, 0x88, 0x46, 0xEE, 0xB8, 0x14, 0xDE, 0x5E, 0x0B, 0xDB],
    [0xE0, 0x32, 0x3A, 0x0A, 0x49, 0x06, 0x24, 0x5C, 0xC2, 0xD3, 0xAC, 0x62, 0x91, 0x95, 0xE4, 0x79],
    [0xE7, 0xC8, 0x37, 0x6D, 0x8D, 0xD5, 0x4E, 0xA9, 0x6C, 0x56, 0xF4, 0xEA, 0x65, 0x7A, 0xAE, 0x08],
    [0xBA, 0x78, 0x25, 0x2E, 0x1C, 0xA6, 0xB4, 0xC6, 0xE8, 0xDD, 0x74, 0x1F, 0x4B, 0xBD, 0x8B, 0x8A],
    [0x70, 0x3E, 0xB5, 0x66, 0x48, 0x03, 0xF6, 0x0E, 0x61, 0x35, 0x57, 0xB9, 0x86, 0xC1, 0x1D, 0x9E],
    [0xE1, 0xF8, 0x98, 0x11, 0x69, 0xD9, 0x8E, 0x94, 0x9B, 0x1E, 0x87, 0xE9, 0xCE, 0x55, 0x28, 0xDF],
    [0x8C, 0xA1, 0x89, 0x0D, 0xBF, 0xEF, 0x98, 0xA1, 0xD3, 0xA5, 0xBA, 0x55, 0x74, 0x4A, 0xC2, 0x1B]
]

def rcon(value):
    """Return the Rcon value for key expansion."""
    c = 1
    if value == 0:
        return 0
    while value != 1:
        c = gmul_2(c)
        value -= 1
    return c

def rotate_word(word):
    """Rotate the word for key expansion."""
    temp = word[0]
    word[0] = word[1]
    word[1] = word[2]
    word[2] = word[3]
    word[3] = temp

def sub_word(word):
    """Substitute bytes in the word using the S-Box."""
    for i in range(4):
        byte = word[i]
        word[i] = s_box[byte >> 4][byte & 0x0F]

def key_expansion(key):
    """Perform key expansion for AES."""
    round_keys = [[0]*4 for _ in range(44)]  # Adjust size for different key lengths
    temp = [0] * 4

    # Copy the initial key
    for i in range(Nk):
        round_keys[i][0] = key[4 * i]
        round_keys[i][1] = key[4 * i + 1]
        round_keys[i][2] = key[4 * i + 2]
        round_keys[i][3] = key[4 * i + 3]

    # Generate round keys
    for i in range(Nk, Nb * (Nr + 1)):
        temp[0] = round_keys[i - 1][0]
        temp[1] = round_keys[i - 1][1]
        temp[2] = round_keys[i - 1][2]
        temp[3] = round_keys[i - 1][3]

        if i % Nk == 0:
            rotate_word(temp)
            sub_word(temp)
            temp[0] ^= rcon(i // Nk)
        
        round_keys[i][0] = round_keys[i - Nk][0] ^ temp[0]
        round_keys[i][1] = round_keys[i - Nk][1] ^ temp[1]
        round_keys[i][2] = round_keys[i - Nk][2] ^ temp[2]
        round_keys[i][3] = round_keys[i - Nk][3] ^ temp[3]

    return round_keys

def add_round_key(state, key):
    """Add round key to the state."""
    for i in range(4):
        for j in range(4):
            state[i][j] ^= key[i * 4 + j]

def sub_bytes(state):
    """Substitute bytes using the S-Box."""
    for i in range(4):
        for j in range(4):
            byte = state[i][j]
            state[i][j] = s_box[byte >> 4][byte & 0x0F]

def shift_rows(state):
    """Shift rows in the state."""
    # Shift first row by 0
    # Shift second row by 1
    temp = state[1][0]
    state[1][0] = state[1][1]
    state[1][1] = state[1][2]
    state[1][2] = state[1][3]
    state[1][3] = temp

    # Shift third row by 2
    temp1, temp2 = state[2][0], state[2][1]
    state[2][0] = state[2][2]
    state[2][1] = state[2][3]
    state[2][2] = temp1
    state[2][3] = temp2

    # Shift fourth row by 3
    temp = state[3][3]
    state[3][3] = state[3][2]
    state[3][2] = state[3][1]
    state[3][1] = state[3][0]
    state[3][0] = temp

def mix_columns(state):
    """Mix columns of the state."""
    for i in range(4):
        col = [state[j][i] for j in range(4)]
        state[0][i] = gmul_2(col[0]) ^ gmul_1(col[1]) ^ col[2] ^ col[3]
        state[1][i] = col[0] ^ gmul_2(col[1]) ^ gmul_1(col[2]) ^ col[3]
        state[2][i] = col[0] ^ col[1] ^ gmul_2(col[2]) ^ gmul_1(col[3])
        state[3][i] = gmul_1(col[0]) ^ col[1] ^ col[2] ^ gmul_2(col[3])

def gmul_2(x):
    """Multiply by 2 in GF(2^8)."""
    if x & 0x80:
        return (x << 1) ^ 0x1B
    else:
        return (x << 1)

def gmul_1(x):
    """Multiply by 1 in GF(2^8) (identity)."""
    return x

def aes_encrypt(plain_text, key):
    """Encrypt the plaintext using AES with the given key."""
    state = [[0]*4 for _ in range(4)]
    
    # Convert plaintext from binary string to state matrix
    for i in range(4):
        for j in range(4):
            index = i * 4 + j
            state[j][i] = plain_text[index]

    # Key expansion
    round_keys = key_expansion(key)

    # Initial round
    add_round_key(state, round_keys[0])

    # Main rounds
    for round in range(1, Nr):
        sub_bytes(state)
        shift_rows(state)
        mix_columns(state)
        add_round_key(state, round_keys[round])

    # Final round
    sub_bytes(state)
    shift_rows(state)
    add_round_key(state, round_keys[Nr])

    # Convert state matrix back to ciphertext
    cipher_text = []
    for i in range(4):
        for j in range(4):
            cipher_text.append(state[j][i])

    return cipher_text
