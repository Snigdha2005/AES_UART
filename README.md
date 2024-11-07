# AES_UART

## Project Description

This project implements AES (Advanced Encryption Standard) encryption and decryption on FPGA to enable secure data transmission and reception via UART. Supporting 128-, 192-, and 256-bit keys, the system handles 128-bit data blocks, converting binary input into a 4x4 matrix for efficient processing through AES rounds, including byte substitution, row shifting, column mixing, and round key addition. FPGA-specific optimizations like loop unrolling and pipelining enhance performance, enabling fast and secure data transfers. The UART protocol has been adapted from an 8-bit to a 128-bit format to facilitate efficient encrypted communication, making this design well-suited for embedded systems and secure communication applications.

## Repository Structure

AES - Contains all the AES version folders with .c, .py and .v files for design and simulation
UART - Contains all the UART version folders with .v files
Integrated UART AES
