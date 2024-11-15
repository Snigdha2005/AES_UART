#include "C:\Users\SnigdhaYS\AppData\Roaming\Xilinx\Vitis\AES_2.h"

const unsigned char Rcon[10] = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x1B, 0x36};

const unsigned char s_box[16][16] = {
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



void sub_bytes(unsigned char state[4][4]){
	for(int i = 0; i < 4; i++){
		for(int j = 0;  j < 4; j++){
//#pragma HLS UNROLL factor = 2
			state[i][j] = s_box[state[i][j] >> 4][state[i][j] & 0x0F];
			// printf("%0x", s_box[i][j]);
		}
	}
}

void sub_word(unsigned char* word) {
    for (int i = 0; i < 4; i++) {
//#pragma HLS UNROLL factor = 2
        unsigned char byte = word[i];
        word[i] = s_box[byte >> 4][byte & 0x0F];
    }
}

void key_expansion(unsigned char* key, unsigned char round_keys[4 * (Nr + 1)][4]) {
    unsigned char temp[4];

    for (int i = 0; i < Nk; i++) {
//#pragma HLS UNROLL factor = 2
        round_keys[i][0] = key[4 * i];
        round_keys[i][1] = key[4 * i + 1];
        round_keys[i][2] = key[4 * i + 2];
        round_keys[i][3] = key[4 * i + 3];
    }

    for (int i = Nk; i < Nb * (Nr + 1); i++) {
        for (int j = 0; j < 4; j++) {
//#pragma HLS UNROLL factor = 2
            temp[j] = round_keys[i - 1][j];
        }

        if (i % Nk == 0) {
            rotate_word(temp);
            sub_word(temp);
            temp[0] ^= Rcon[i / Nk - 1];
        } else if (Nk > 6 && i % Nk == 4) {  // Additional sub_word for AES-256
            sub_word(temp);
        }

        for (int j = 0; j < 4; j++) {
//#pragma HLS UNROLL factor = 2
            round_keys[i][j] = round_keys[i - Nk][j] ^ temp[j];
        }
    }
}

void shift_rows(unsigned char state[4][4]){
	unsigned char temp[4][4];
	for(int i = 0; i < 4; i++){
		for(int j = 0; j < 4; j++){
//#pragma HLS UNROLL factor = 2
			temp[i][j] = state[i][j];
		}
	}
	for (int i = 1; i < 4; i++){
        for (int j = 0; j < 4; j++){
//#pragma HLS UNROLL factor = 2
            state[i][j] = temp[i][(j + i) % 4];   
        }
    }
}


void mix_columns(unsigned char state[4][4]){
	unsigned char temp[4][4];
	for(int i = 0; i < 4; i++){
		for(int j = 0; j < 4; j++){
//#pragma HLS UNROLL factor = 2
			temp[i][j] = state[i][j];
		}
	}
	for (int i = 0; i < 4; i++){
//#pragma HLS UNROLL factor = 2
        state[0][i] = (gmul_2(temp[0][i]))^(gmul_3(temp[1][i]))^(1 * temp[2][i])^(1 * temp[3][i]);
        state[1][i] = (1 * temp[0][i])^(gmul_2(temp[1][i]))^(gmul_3(temp[2][i]))^(1 * temp[3][i]);
        state[2][i] = (1 * temp[0][i])^(1 * temp[1][i])^(gmul_2(temp[2][i]))^(gmul_3(temp[3][i]));
        state[3][i] = (gmul_3(temp[0][i]))^(1 * temp[1][i])^(1 * temp[2][i])^(gmul_2(temp[3][i]));    
    }
}

void add_round_key(unsigned char mixed[4][4], unsigned char round_key[4 * (Nr + 1)][4], int round){
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
//#pragma HLS UNROLL factor = 2
            mixed[i][j] ^= round_key[round * 4 +  i][j]; 
        }
    }
}

void AES_encrypt(bool * plain_text, unsigned char * key, bool * cipher_text){
//#pragma HLS PIPELINE
//	#pragma HLS STREAM
    unsigned char state[4][4];
	unsigned char round_key[4 * (Nr + 1)][4];
    matrix_conversion(plain_text, state);
	key_expansion(key, round_key);
	add_round_key(state, round_key, 0);
	for(int round = 1; round < Nr; round++){
		sub_bytes(state);
		shift_rows(state);
		mix_columns(state);
		add_round_key(state, round_key, round);
	}
	sub_bytes(state);
	shift_rows(state);
	add_round_key(state, round_key, Nr);
	matrix_flatten(state, cipher_text);
}

// int main(){
//     int plain_text[128] = {
// 			1, 0, 1, 0, 0, 1, 1, 0, // 1st byte
// 			1, 1, 0, 0, 1, 0, 0, 1, // 2nd byte
// 			0, 1, 1, 0, 0, 0, 1, 1, // 3rd byte
// 			1, 0, 1, 1, 0, 1, 0, 0, // 4th byte
// 			0, 0, 0, 1, 1, 1, 0, 1, // 5th byte
// 			1, 1, 1, 0, 1, 0, 1, 1, // 6th byte
// 			0, 1, 0, 1, 1, 0, 0, 1, // 7th byte
// 			1, 1, 1, 1, 0, 0, 0, 1, // 8th byte
// 			0, 1, 1, 0, 1, 0, 1, 1, // 9th byte
// 			1, 0, 1, 0, 0, 1, 1, 0, // 10th byte
// 			1, 1, 1, 0, 1, 0, 1, 1, // 11th byte
// 			1, 0, 1, 0, 0, 1, 1, 1, // 12th byte
// 			0, 1, 0, 1, 1, 1, 0, 0, // 13th byte
// 			1, 1, 1, 1, 0, 1, 1, 0, // 14th byte
// 			0, 1, 0, 1, 1, 0, 0, 0, // 15th byte
// 			1, 0, 1, 1, 1, 1, 0, 1  // 16th byte
// 	};
// 	unsigned char key[16] = {
//     0x2B, 0x7E, 0x15, 0x16,
//     0x28, 0xAE, 0xD2, 0xA6,
//     0xAB, 0xF7, 0x97, 0x76,
//     0x45, 0x39, 0x60, 0x3D
// 	};

// 	int cipher_text[128];

// 	AES_encrypt(plain_text, key, cipher_text);
	// for(int i = 0; i < 128; i++){
	// 	printf("%d ", cipher_text[i]);
	// }
//     unsigned char state[4][4];
//     matrix_conversion(plain_text, state);
// 	sub_bytes(state);
//     for(int i = 0; i < 4; i++){
//         for(int j = 0;  j < 4; j++){
//             printf("%x ", state[i][j]);
//         }
//         printf("\n");
//     }
// 	shift_rows(state);
// 	for(int i = 0; i < 4; i++){
//         for(int j = 0;  j < 4; j++){
//             printf("%x ", state[i][j]);
//         }
//         printf("\n");
//     }
// }
