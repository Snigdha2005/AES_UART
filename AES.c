#include "AES.h"

void AES(plain plain_text[128], cipher cipher_text[128], fl flag, key key[16]) {
    if (flag == 0) {
        AES_encrypt(plain_text, key, cipher_text);
    }
    else if (flag == 1){
        AES_decrypt(cipher_text, key, plain_text);
    }
}
