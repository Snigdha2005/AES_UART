#include "AES_2.h"

void matrix_conversion(bool * plain_text, unsigned char state[4][4]){
	int k = 0;
    for(int i = 0; i < 4; i++){
		for(int j = 0; j < 4; j++){
			int a = (plain_text[k] == 1)? 1:0;
			int b = (plain_text[k+1] == 1)? 1:0;
			int c = (plain_text[k+2] == 1)? 1:0;
			int d = (plain_text[k+3] == 1)? 1:0;
			int e = (plain_text[k+4] == 1)? 1:0;
			int f = (plain_text[k+5] == 1)? 1:0;
			int g = (plain_text[k+6] == 1)? 1:0;
			int h = (plain_text[k+7] == 1)? 1:0;
			state[i][j] = (unsigned char)(a << 7 | b << 6 | c << 5 | d << 4 | e << 3 | f << 2 | g << 1 | h);
			k = k + 8;
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

void rotate_word(unsigned char* word) {
    unsigned char temp = word[0];
    word[0] = word[1];
    word[1] = word[2];
    word[2] = word[3];
    word[3] = temp;
}

void matrix_flatten(unsigned char state[4][4], bool * cipher_text){
	int index = 0;

    for (int i = 0; i < 4; i++) {
//#pragma HLS UNROLL factor = 2
        for (int j = 0; j < 4; j++) {
            for (int bit = 7; bit >= 0; bit--) {
                cipher_text[index++] = (state[i][j] >> bit) & 1;
            }
        }
    }
}


void AES(plain plain_text[128], cipher cipher_text[128], key key[16]) {
//#pragma HLS PIPELINE
//#pragma HLS STREAM
//#pragma HLS dataflow

     AES_encrypt(plain_text, key, cipher_text);
}
