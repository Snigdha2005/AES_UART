#include<stdio.h>
#include <stdbool.h>
#include <stdlib.h>

#define HW_COSIM

#define Nk 4          // AES - 128 = 4, 192 = 6, 256 = 8
#define Nb 4          // Number of columns in the state
#define Nr 10         // AES - 128 = 10, 192 = 12, 256 = 14


typedef bool plain;
typedef bool cipher;
typedef unsigned char key;
//typedef bool fl;


void matrix_conversion(bool *plain_text, unsigned char state[4][4]);
void sub_bytes(unsigned char state[4][4]);
void shift_rows(unsigned char state[4][4]);
unsigned char gmul_2(unsigned char a);
unsigned char gmul_3(unsigned char a);
void mix_columns(unsigned char state[4][4]);
void rotate_word(unsigned char *word);
void sub_word(unsigned char *word);
void key_expansion(unsigned char *key, unsigned char round_keys[4 * (Nr + 1)][4]);
void add_round_key(unsigned char mixed[4][4], unsigned char round_key[4 * (Nr + 1)][4], int round);
void matrix_flatten(unsigned char state[4][4], bool *cipher_text);
void AES_encrypt(bool *plain_text, unsigned char *key, bool *cipher_text);

void AES(plain plain_text[128], cipher cipher_text[128], key key[16]);

