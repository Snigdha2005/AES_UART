#include<stdio.h>
#include <stdbool.h>
#include <stdlib.h>

#define HW_COSIM

#define Nb 4
#define Nk 4
#define Nr 10

typedef int plain;
typedef int cipher;
typedef unsigned char key;
typedef int fl;


void custom_strcpy(char *dest, const char *src);
int custom_strtol(const char *str, int base);
void custom_sprintf(char *buffer, int value);

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

unsigned char rcon(unsigned char value);
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

void AES(plain plain_text[128], cipher cipher_text[128], fl flag, key key[16]);

