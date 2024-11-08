

import serial
import time

# Initialize serial communication
ComPort = serial.Serial('COM4')  # Change to your correct COM port
ComPort.baudrate = 115200        # Set Baud rate
ComPort.bytesize = 8             # 8 data bits
ComPort.parity   = 'N'           # No parity
ComPort.stopbits = 1             # 1 Stop bit

N_RECEIVED_BYTES = 2  # Total bytes to receive (128 bits / 8 bits per byte)

print("Waiting for 128-bit data...")

# Initialize an empty list to store the received bytes
received_data = []

while len(received_data) < N_RECEIVED_BYTES:
    byte = ComPort.read(1)  # Read one byte at a time
    if byte:
        data_byte = int.from_bytes(byte, byteorder='big')
        received_data.append(data_byte)
        print(f"Received byte: {data_byte}")

# Close the COM port
ComPort.close()

# Combine the received bytes into a single 128-bit integer
full_data = 0
for byte in received_data:
    full_data = (full_data << 8) | byte  # Shift left by 8 bits and add the new byte

print(f"Received full 128-bit data: {full_data:#034b}")  # Binary representation
print(f"Received full 128-bit data (hex): {full_data:#034x}")  # Hex representation
