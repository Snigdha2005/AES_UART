#include "AES.h"


unsigned char inv_rcon(unsigned char value);
void inv_rotate_word(unsigned char* word);
void inv_sub_word(unsigned char* word);
void inv_key_expansion(unsigned char* key, unsigned char round_keys[44][4]);
void inv_matrix_construction(int *cipher_text, unsigned char matrix[4][4]);
unsigned char inv_gmul(unsigned char a, unsigned char b);
unsigned char inv_gmul_2(unsigned char a);
unsigned char inv_gmul_3(unsigned char a);
void inv_add_round_key(unsigned char state[4][4], unsigned char round_keys[44][4], int round);
void inv_mix_columns(unsigned char state[4][4], unsigned char mixed[4][4]);
void inv_shift_rows(unsigned char state[4][4], unsigned char shifted_rows[4][4]);
void inv_sub_bytes(unsigned char state[4][4], unsigned char s_box_matrix[4][4]);
void AES_decrypt(int *cipher_text, unsigned char *key, int *plain_text);

unsigned char inv_Rcon[10] = { 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x1B, 0x36 };

unsigned char inv_s_box[16][16] = {
    {0x52, 0x09, 0x6a, 0xd5, 0x30, 0x36, 0xa5, 0x38, 0xbf, 0x40, 0xa3, 0x9e, 0x81, 0xf3, 0xd7, 0xfb},
    {0x7c, 0xe3, 0x39, 0x82, 0x9b, 0x2f, 0xff, 0x87, 0x34, 0x8e, 0x43, 0x44, 0xc4, 0xde, 0xe9, 0xcb},
    {0x54, 0x7b, 0x94, 0x32, 0xa6, 0xc2, 0x23, 0x3d, 0xee, 0x4c, 0x95, 0x0b, 0x42, 0xfa, 0xc3, 0x4e},
    {0x08, 0x2e, 0xa1, 0x66, 0x28, 0xd9, 0x24, 0xb2, 0x76, 0x5b, 0xa2, 0x49, 0x6d, 0x8b, 0xd1, 0x25},
    {0x72, 0xf8, 0xf6, 0x64, 0x86, 0x68, 0x98, 0x16, 0xd4, 0xa4, 0x5c, 0xcc, 0x5d, 0x65, 0xb6, 0x92},
    {0x6c, 0x70, 0x48, 0x50, 0xfd, 0xed, 0xb9, 0xda, 0x5e, 0x15, 0x46, 0x57, 0xa7, 0x8d, 0x9d, 0x84},
    {0x90, 0xd8, 0xab, 0x00, 0x8c, 0xbc, 0xd3, 0x0a, 0xf7, 0xe4, 0x58, 0x05, 0xb8, 0x3b, 0x45, 0x06},
    {0xd0, 0x2c, 0x1e, 0x8f, 0xca, 0x3f, 0x0f, 0x02, 0xc1, 0xaf, 0xbd, 0x03, 0x01, 0x13, 0x8a, 0x6b},
    {0x3a, 0x91, 0x11, 0x41, 0x4f, 0x67, 0xdc, 0xea, 0x97, 0xf2, 0xcf, 0xce, 0xf0, 0xb4, 0xe6, 0x73},
    {0x96, 0xac, 0x74, 0x22, 0xe7, 0xad, 0x35, 0x85, 0xe2, 0xf9, 0x37, 0xe8, 0x1c, 0x75, 0xdf, 0x6e},
    {0x47, 0xf1, 0x1a, 0x71, 0x1d, 0x29, 0xc5, 0x89, 0x6f, 0xb7, 0x62, 0x0e, 0xaa, 0x18, 0xbe, 0x1b},
    {0xfc, 0x56, 0x3e, 0x4b, 0xc6, 0xd2, 0x79, 0x20, 0x9a, 0xdb, 0xc0, 0xfe, 0x78, 0xcd, 0x5a, 0xf4},
    {0x1f, 0xdd, 0xa8, 0x33, 0x88, 0x07, 0xc7, 0x31, 0xb1, 0x12, 0x10, 0x59, 0x27, 0x80, 0xec, 0x5f},
    {0x60, 0x51, 0x7f, 0xa9, 0x19, 0xb5, 0x4a, 0x0d, 0x2d, 0xe5, 0x7a, 0x9f, 0x93, 0xc9, 0x9c, 0xef},
    {0xa0, 0xe0, 0x3b, 0x4d, 0xae, 0x2a, 0xf5, 0xb0, 0xc8, 0xeb, 0xbb, 0x3c, 0x83, 0x53, 0x99, 0x61},
    {0x17, 0x2b, 0x04, 0x7e, 0xba, 0x77, 0xd6, 0x26, 0xe1, 0x69, 0x14, 0x63, 0x55, 0x21, 0x0c, 0x7d}
};

unsigned char inv_gmul_2(unsigned char a){
    unsigned char h = a & 0x80;
    unsigned char b = a << 1;
    if (h == 0x80){
        b = b ^ 0x1b;
    }
    return b;
}

unsigned char inv_gmul_3(unsigned char a){
    return a ^ inv_gmul_2(a);
}

unsigned char inv_rcon(unsigned char value){
    unsigned char c = 1;
    if (value == 0) return 0;
    while (value != 1){
        c = inv_gmul_2(c);
        value--;
    }
    return c;
}

void inv_rotate_word(unsigned char* word) {
    unsigned char temp = word[0];
    word[0] = word[1];
    word[1] = word[2];
    word[2] = word[3];
    word[3] = temp;
}

void inv_sub_word(unsigned char* word) {
    for (int i = 0; i < 4; i++) {
        unsigned char byte = word[i];
        word[i] = inv_s_box[byte >> 4][byte & 0x0F];
    }
}

void inv_key_expansion(unsigned char* key, unsigned char round_keys[44][4]) {
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
            inv_rotate_word(temp);
            inv_sub_word(temp);
            temp[0] ^= inv_Rcon[i / Nk - 1];
        }

        for (int j = 0; j < 4; j++) {
            round_keys[i][j] = round_keys[i - Nk][j] ^ temp[j];
        }
    }
}

void inv_matrix_construction(int *cipher_text, unsigned char matrix[4][4]) {
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            matrix[j][i] = (unsigned char)cipher_text[i * 4 + j];
        }
    }
}

unsigned char inv_gmul(unsigned char a, unsigned char b){
    unsigned char p = 0x00;
    for(int i = 0; i < 8; i++){
        if((b & 1) != 0){
            p = p^a;
        }
        bool h = (a & 0x80) != 0;
        a = a << 1;
        if(h){
            a = a ^ 0x1B;
        }
        b = b >> 1;
        return p;
    }
    return p;
}

void inv_add_round_key(unsigned char state[4][4], unsigned char round_keys[44][4], int round){
    unsigned char temp[4][4];
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            temp[i][j] ^= round_keys[round * 4 +  i][j]; 
        }
    }
    for (int i = 0; i < 4; i++){
        for(int j = 0; j < 4; j++){
            state[i][j] = temp[3 - i][j];
        }
    }
}

void inv_mix_columns(unsigned char state[4][4], unsigned char mixed[4][4]){
    for(int i = 0; i < 4; i++){
        mixed[0][i] = inv_gmul(14, state[0][i]) ^ inv_gmul(11, state[1][i]) ^ inv_gmul(13, state[2][i]) ^ inv_gmul(9, state[3][i]);
        mixed[1][i] = inv_gmul(9, state[0][i]) ^ inv_gmul(14, state[1][i]) ^ inv_gmul(11, state[2][i]) ^ inv_gmul(13, state[3][i]);
        mixed[2][i] = inv_gmul(13, state[0][i]) ^ inv_gmul(9, state[1][i]) ^ inv_gmul(14, state[2][i]) ^ inv_gmul(11, state[3][i]);
        mixed[3][i] = inv_gmul(11, state[0][i]) ^ inv_gmul(13, state[1][i]) ^ inv_gmul(9, state[2][i]) ^ inv_gmul(14, state[3][i]);
    }
}

void inv_shift_rows(unsigned char state[4][4], unsigned char shifted_rows[4][4]){
    for (int i = 0; i < 4; i++) {
        shifted_rows[0][i] = state[0][i];
    }

    for (int i = 0; i < 4; i++) {
        shifted_rows[1][i] = state[1][(i + 1) % 4];
    }

    for (int i = 0; i < 4; i++) {
        shifted_rows[2][i] = state[2][(i + 2) % 4];
    }

    for (int i = 0; i < 4; i++) {
        shifted_rows[3][i] = state[3][(i + 3) % 4];
    }
}

void inv_sub_bytes(unsigned char state[4][4], unsigned char s_box_matrix[4][4]){
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            unsigned char byte = state[i][j];
            s_box_matrix[i][j] = inv_s_box[byte >> 4][byte & 0x0F];
        }
    }
}

void AES_decrypt(int * cipher_text, unsigned char * key, int * plain_text){
    unsigned char state[4][4];           
    unsigned char round_keys[44][4];      
    unsigned char shifted_rows[4][4];     
    unsigned char s_box_matrix[4][4];     
    unsigned char mixed[4][4];            

    inv_matrix_construction(cipher_text, state);
    inv_key_expansion(key, round_keys);

    inv_add_round_key(state, round_keys, 0);
    inv_shift_rows(state, shifted_rows);
    inv_sub_bytes(state, s_box_matrix);
    for(int i = 0; i < 4; i++){
        for(int j = 0; j < 4; j++){
                state[i][j] = s_box_matrix[i][j];
        }
    }

    for(int i = 1; i < 10; i++){
        inv_add_round_key(state, round_keys, i);
        inv_mix_columns(state, mixed);
        inv_shift_rows(mixed, shifted_rows);
        inv_sub_bytes(shifted_rows, s_box_matrix);
        for(int i = 0; i < 4; i++){
            for(int j = 0; j < 4; j++){
                state[i][j] = s_box_matrix[i][j];
            }
        }
    }
    inv_add_round_key(state, round_keys, 10);
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            plain_text[i * 4 + j] = (int)state[j][i];
        }
    }
}
