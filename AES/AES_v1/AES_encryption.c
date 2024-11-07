
#include "AES.h"

void hexadecimal_conversion(int *plain_text, char *hex_plain_text);
unsigned char rcon(unsigned char value);
void rotate_word(unsigned char* word);
void sub_word(unsigned char* word);
void key_expansion(unsigned char* key, unsigned char round_keys[44][4]);
void matrix_construction(int *plain_text, char data_matrix[4][4][3]);
void sub_bytes(char data_matrix[4][4][3], unsigned char s_box_matrix[4][4]);
void shift_rows(unsigned char s_box_matrix[4][4], unsigned char s_box_shifted[4][4]);
unsigned char gmul_2(unsigned char a);
unsigned char gmul_3(unsigned char a);
void mix_columns(unsigned char s_box_shifted[4][4], unsigned char mixed[4][4]);
void add_round_key(unsigned char mixed[4][4], unsigned char round_key[44][4], int round);
void data_state(char data_matrix[4][4][3], unsigned char state[4][4]);
void state_data(char data_matrix[4][4][3], unsigned char state[4][4]);
void AES_encrypt(int * plain_text, unsigned char * key, int * cipher_text);

unsigned char Rcon[10] = { 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x1B, 0x36 };

unsigned char s_box[16][16] = {
    {0x63, 0x7C, 0x77, 0x7B, 0xF2, 0x6B, 0x6F, 0xC5, 0x30, 0x01, 0x67, 0x2B, 0xFE, 0xD7, 0xAB, 0x76},
    {0xCA, 0x82, 0xC9, 0x7D, 0xFA, 0x59, 0x47, 0xF0, 0xAD, 0xD4, 0xA2, 0xAF, 0x9C, 0xA4, 0x72, 0xC0},
    {0xB7, 0xFD, 0x93, 0x26, 0x36, 0x3F, 0xF7, 0xCC, 0x34, 0xA5, 0xE5, 0xF1, 0x71, 0xD8, 0x31, 0x15},
    {0x04, 0xC7, 0x23, 0xC3, 0x18, 0x96, 0x05, 0x9A, 0x07, 0x12, 0x80, 0xE2, 0xEB, 0x27, 0xB2, 0x75},
    {0x09, 0x83, 0x2C, 0x1A, 0x1B, 0x6E, 0x5A, 0xA0, 0x52, 0x3B, 0xD6, 0xB3, 0x29, 0xE3, 0x2F, 0x84},
    {0x53, 0xD1, 0x00, 0xED, 0x20, 0xFC, 0xB1, 0x5B, 0x6A, 0xCB, 0xBE, 0x39, 0x4A, 0x4C, 0x58, 0xCF},
    {0xD0, 0xEF, 0xAA, 0xFB, 0x43, 0x4D, 0x33, 0x85, 0x45, 0xF9, 0x02, 0x7F, 0x50, 0x3C, 0x9F, 0xA8},
    {0x51, 0xA3, 0x40, 0x8F, 0x92, 0x9D, 0x38, 0xF5, 0xBC, 0xB6, 0xDA, 0x21, 0x10, 0xFF, 0xF3, 0xD2},
    {0xCD, 0x0C, 0x13, 0xEC, 0x5F, 0x97, 0x44, 0x17, 0xC4, 0xA7, 0x7E, 0x3D, 0x64, 0x5D, 0x19, 0x73},
    {0x60, 0x81, 0x4F, 0xDC, 0x22, 0x2A, 0x90, 0x88, 0x46, 0xEE, 0xB8, 0x14, 0xDE, 0x5E, 0x0B, 0xDB},
    {0xE0, 0x32, 0x3A, 0x0A, 0x49, 0x06, 0x24, 0x5C, 0xC2, 0xD3, 0xAC, 0x62, 0x91, 0x95, 0xE4, 0x79},
    {0xE7, 0xC8, 0x37, 0x6D, 0x8D, 0xD5, 0x4E, 0xA9, 0x6C, 0x56, 0xF4, 0xEA, 0x65, 0x7A, 0xAE, 0x08},
    {0xBA, 0x78, 0x25, 0x2E, 0x1C, 0xA6, 0xB4, 0xC6, 0xE8, 0xDD, 0x74, 0x1F, 0x4B, 0xBD, 0x8B, 0x8A},
    {0x70, 0x3E, 0xB5, 0x66, 0x48, 0x03, 0xF6, 0x0E, 0x61, 0x35, 0x57, 0xB9, 0x86, 0xC1, 0x1D, 0x9E},
    {0xE1, 0xF8, 0x98, 0x11, 0x69, 0xD9, 0x8E, 0x94, 0x9B, 0x1E, 0x87, 0xE9, 0xCE, 0x55, 0x28, 0xDF},
    {0x8C, 0xA1, 0x89, 0x0D, 0xBF, 0xEF, 0x98, 0xA1, 0xD3, 0xA5, 0xBA, 0x55, 0x74, 0x4A, 0xC2, 0x1B}
};

void custom_strcpy(char *dest, const char *src) {
    while (*src) {
        *dest++ = *src++;
    }
    *dest = '\0';  // Null-terminate the destination string
}

int custom_strtol(const char *str, int base) {
    int result = 0;
    int sign = 1;

    // Check for negative numbers
    if (*str == '-') {
        sign = -1;
        str++;
    }

    // Iterate over each character in the string
    while (*str) {
        int digit = 0;

        if (*str >= '0' && *str <= '9') {
            digit = *str - '0';
        } else if (*str >= 'a' && *str <= 'f') {
            digit = *str - 'a' + 10;
        } else if (*str >= 'A' && *str <= 'F') {
            digit = *str - 'A' + 10;
        } else {
            break;  // Stop if an invalid character is encountered
        }

        // Check that digit is within the base
        if (digit >= base) {
            break;
        }

        result = result * base + digit;
        str++;
    }

    return result * sign;
}

void custom_sprintf(char *buffer, int value) {
    char temp[10];  // Temporary buffer for reversed digits
    int i = 0;

    // Handle zero case
    if (value == 0) {
        buffer[0] = '0';
        buffer[1] = '\0';
        return;
    }

    // Convert each digit to character and store in reverse order
    while (value > 0) {
        temp[i++] = (value % 10) + '0';
        value /= 10;
    }

    // Reverse the string to get the correct order
    int j = 0;
    while (i > 0) {
        buffer[j++] = temp[--i];
    }
    buffer[j] = '\0';  // Null-terminate the result
}

void hexadecimal_conversion(int *plain_text, char *hex_plain_text) {
    for (int i = 0; i < 32; i += 4) {
        int group = (plain_text[i] << 3) | (plain_text[i+1] << 2) | (plain_text[i+2] << 1) | plain_text[i+3];
        
        switch (group) {
            case 0: hex_plain_text[i / 4] = '0'; break;
            case 1: hex_plain_text[i / 4] = '1'; break;
            case 2: hex_plain_text[i / 4] = '2'; break;
            case 3: hex_plain_text[i / 4] = '3'; break;
            case 4: hex_plain_text[i / 4] = '4'; break;
            case 5: hex_plain_text[i / 4] = '5'; break;
            case 6: hex_plain_text[i / 4] = '6'; break;
            case 7: hex_plain_text[i / 4] = '7'; break;
            case 8: hex_plain_text[i / 4] = '8'; break;
            case 9: hex_plain_text[i / 4] = '9'; break;
            case 10: hex_plain_text[i / 4] = 'A'; break;
            case 11: hex_plain_text[i / 4] = 'B'; break;
            case 12: hex_plain_text[i / 4] = 'C'; break;
            case 13: hex_plain_text[i / 4] = 'D'; break;
            case 14: hex_plain_text[i / 4] = 'E'; break;
            case 15: hex_plain_text[i / 4] = 'F'; break;
        }
    }
    hex_plain_text[33] = '\0';
}

unsigned char rcon(unsigned char value){
    unsigned char c = 1;
    if (value == 0) return 0;
    while (value != 1){
        c = gmul_2(c);
        value--;
    }
    return c;
}

void rotate_word(unsigned char* word) {
    unsigned char temp = word[0];
    word[0] = word[1];
    word[1] = word[2];
    word[2] = word[3];
    word[3] = temp;
}

void sub_word(unsigned char* word) {
    for (int i = 0; i < 4; i++) {
        unsigned char byte = word[i];
        word[i] = s_box[byte >> 4][byte & 0x0F];
    }
}

void key_expansion(unsigned char* key, unsigned char round_keys[44][4]) {
    unsigned char temp[4]; 

    for (int i = 0; i < Nk; i++) {
        round_keys[i][0] = key[4 * i];
        round_keys[i][1] = key[4 * i + 1];
        round_keys[i][2] = key[4 * i + 2];
        round_keys[i][3] = key[4 * i + 3];
    }

    for (int i = Nk; i < Nb * (Nr + 1); i++) {
        for (int j = 0; j < 4; j++) {
            temp[j] = round_keys[i - 1][j];
        }

        if (i % Nk == 0) {
            rotate_word(temp);          
            sub_word(temp);             
            temp[0] ^= Rcon[i / Nk - 1]; 
        }

        for (int j = 0; j < 4; j++) {
            round_keys[i][j] = round_keys[i - Nk][j] ^ temp[j];
        }
    }
}

void matrix_construction(int *plain_text, char data_matrix[4][4][3]) {
    int rows = 4;
    int columns = 4;
    char hex_plain_text[33]; 
    hexadecimal_conversion(plain_text, hex_plain_text);

    int k = 0;
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < columns; j++) {
            char hex_pair[3];
            hex_pair[0] = hex_plain_text[k];       
            hex_pair[1] = hex_plain_text[k + 1];   
            hex_pair[2] = '\0';                    

            custom_strcpy(data_matrix[i][j], hex_pair);

            k += 2;
        }
    }
}

void sub_bytes(char data_matrix[4][4][3], unsigned char s_box_matrix[4][4]){
    for (int i = 0; i < 4; i++){
        for (int j = 0; j < 4; j++){
            int row = (data_matrix[i][j][0] >= 'A') ? (data_matrix[i][j][0] - 'A' + 10) : (data_matrix[i][j][0] - '0');
            int col = (data_matrix[i][j][1] >= 'A') ? (data_matrix[i][j][1] - 'A' + 10) : (data_matrix[i][j][1] - '0');
            s_box_matrix[i][j] = s_box[row][col];

        }
    }
}

void shift_rows(unsigned char s_box_matrix[4][4], unsigned char s_box_shifted[4][4]){
    for (int i = 0; i < 4; i++){
        for (int j = 0; j < 4; j++){
            s_box_shifted[i][j] = s_box_matrix[i][(j + i) % 4];   
        }
    }
}

unsigned char gmul_2(unsigned char a){
    unsigned char h = a & 0x80;
    unsigned char b = a << 1;
    if (h == 0x80){
        b = b ^ 0x1b;
    }
    return b;
}

unsigned char gmul_3(unsigned char a){
    return a ^ gmul_2(a);
}

void mix_columns(unsigned char s_box_shifted[4][4], unsigned char mixed[4][4]){
    for (int i = 0; i < 4; i++){
        mixed[0][i] = (gmul_2(s_box_shifted[0][i]))^(gmul_3(s_box_shifted[1][i]))^(1 * s_box_shifted[2][i])^(1 * s_box_shifted[3][i]);
        mixed[1][i] = (1 * s_box_shifted[0][i])^(gmul_2(s_box_shifted[1][i]))^(gmul_3(s_box_shifted[2][i]))^(1 * s_box_shifted[3][i]);
        mixed[2][i] = (1 * s_box_shifted[0][i])^(1 * s_box_shifted[1][i])^(gmul_2(s_box_shifted[2][i]))^(gmul_3(s_box_shifted[3][i]));
        mixed[3][i] = (gmul_3(s_box_shifted[0][i]))^(1 * s_box_shifted[1][i])^(1 * s_box_shifted[2][i])^(gmul_2(s_box_shifted[3][i]));    
    }
}

void add_round_key(unsigned char mixed[4][4], unsigned char round_key[44][4], int round){
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            mixed[i][j] ^= round_key[round * 4 +  i][j]; 
        }
    }
}

//void data_state(char data_matrix[4][4][3], unsigned char state[4][4]){
//    for (int i = 0; i < 4; i++) {
//        for (int j = 0; j < 4; j++) {
//            char hex_pair[3] = {data_matrix[i][j][0], data_matrix[i][j][1], '\0'};
//            state[i][j] = (unsigned char)strtol(hex_pair, NULL, 16); // Convert hex string to byte
//        }
//    }
//}
//
//void state_data(char data_matrix[4][4][3], unsigned char state[4][4]){
//    for (int i = 0; i < 4; i++) {
//        for (int j = 0; j < 4; j++) {
//            sprintf(data_matrix[i][j], "%02X", state[i][j]); // Store as a two-digit hex string
//        }
//    }
//}

void data_state(char data_matrix[4][4][3], unsigned char state[4][4]) {
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            char high_nibble = data_matrix[i][j][0];
            char low_nibble = data_matrix[i][j][1];
            unsigned char value = 0;

            // Convert the first hex character (high nibble)
            if (high_nibble >= '0' && high_nibble <= '9') {
                value = (high_nibble - '0') << 4;
            } else if (high_nibble >= 'A' && high_nibble <= 'F') {
                value = (high_nibble - 'A' + 10) << 4;
            } else if (high_nibble >= 'a' && high_nibble <= 'f') {
                value = (high_nibble - 'a' + 10) << 4;
            }

            // Convert the second hex character (low nibble)
            if (low_nibble >= '0' && low_nibble <= '9') {
                value |= (low_nibble - '0');
            } else if (low_nibble >= 'A' && low_nibble <= 'F') {
                value |= (low_nibble - 'A' + 10);
            } else if (low_nibble >= 'a' && low_nibble <= 'f') {
                value |= (low_nibble - 'a' + 10);
            }

            // Store the byte value in state
            state[i][j] = value;
        }
    }
}

void state_data(char data_matrix[4][4][3], unsigned char state[4][4]) {
    const char hex_chars[] = "0123456789ABCDEF";

    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            unsigned char value = state[i][j];

            // Convert the high nibble to a hex character
            data_matrix[i][j][0] = hex_chars[(value >> 4) & 0x0F];

            // Convert the low nibble to a hex character
            data_matrix[i][j][1] = hex_chars[value & 0x0F];

            // Null-terminate the string
            data_matrix[i][j][2] = '\0';
        }
    }
}

void AES_encrypt(int * plain_text, unsigned char * key, int * cipher_text){

    char data_matrix[4][4][3];
    unsigned char state[4][4];
    unsigned char round_keys[44][4];
    char key_matrix[4][4][3];

    matrix_construction(plain_text, data_matrix);
    data_state(data_matrix, state);
    key_expansion(key, round_keys);
    add_round_key(state, round_keys, 0);

    for (int round = 1; round < 10; round++){
        unsigned char s_box_matrix[4][4];
        unsigned char s_box_shifted[4][4];
        unsigned char mixed[4][4];
        sub_bytes(data_matrix, s_box_matrix);
        shift_rows(s_box_matrix, s_box_shifted);
        mix_columns(s_box_shifted, mixed);
        add_round_key(mixed, round_keys, round);
        for(int i = 0; i < 4; i++){
            for (int j = 0; j < 4; j++){
                state[i][j] = mixed[i][j];
            }
        }
        state_data(data_matrix, state);
    }

    unsigned char final_s_box_matrix[4][4];
    unsigned char final_s_box_shifted[4][4];

    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            int row = (state[i][j] >> 4) & 0x0F;
            int col = state[i][j] & 0x0F;
            final_s_box_matrix[i][j] = s_box[row][col];
        }
    }

    shift_rows(final_s_box_matrix, final_s_box_shifted);
    add_round_key(final_s_box_shifted, round_keys, 10);

    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            unsigned char byte = final_s_box_shifted[i][j];
            for (int k = 0; k < 8; k++) {
                cipher_text[(i + 4 * j) * 8 + k] = (byte >> (7 - k)) & 1;
            }
        }
    }
}
