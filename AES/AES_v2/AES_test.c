#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "AES.h"

int main(int argc, char **argv){
	plain plain_text[128] = {
			1, 0, 1, 0, 0, 1, 1, 0, // 1st byte
			1, 1, 0, 0, 1, 0, 0, 1, // 2nd byte
			0, 1, 1, 0, 0, 0, 1, 1, // 3rd byte
			1, 0, 1, 1, 0, 1, 0, 0, // 4th byte
			0, 0, 0, 1, 1, 1, 0, 1, // 5th byte
			1, 1, 1, 0, 1, 0, 1, 1, // 6th byte
			0, 1, 0, 1, 1, 0, 0, 1, // 7th byte
			1, 1, 1, 1, 0, 0, 0, 1, // 8th byte
			0, 1, 1, 0, 1, 0, 1, 1, // 9th byte
			1, 0, 1, 0, 0, 1, 1, 0, // 10th byte
			1, 1, 1, 0, 1, 0, 1, 1, // 11th byte
			1, 0, 1, 0, 0, 1, 1, 1, // 12th byte
			0, 1, 0, 1, 1, 1, 0, 0, // 13th byte
			1, 1, 1, 1, 0, 1, 1, 0, // 14th byte
			0, 1, 0, 1, 1, 0, 0, 0, // 15th byte
			1, 0, 1, 1, 1, 1, 0, 1  // 16th byte
	};
	cipher cipher_text[128];
	fl flag = 0;
	key key[16] = {
	    0x2b, 0x7e, 0x15, 0x16, // 1st 4 bytes of the key
	    0x28, 0xae, 0xd2, 0xa6, // 2nd 4 bytes of the key
	    0xab, 0xf7, 0xcf, 0x23, // 3rd 4 bytes of the key
	    0x7d, 0x3c, 0x2c, 0x3a  // 4th 4 bytes of the key
	};
	for(int i = 0; i < 128; i++){
				printf("%d ", plain_text[i]);
	}
	printf("\n");
	#ifdef HW_COSIM
		AES(plain_text, cipher_text, flag, key);
		for(int i = 0; i < 128; i++){
			printf("%d ", cipher_text[i]);
		}
		flag = 1;
		AES(plain_text, cipher_text, flag, key);
		printf("\n");
		for(int i = 0; i < 128; i++){
			printf("%d ", plain_text[i]);
		}

	#endif

}
