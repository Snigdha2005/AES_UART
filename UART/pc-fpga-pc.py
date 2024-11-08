import serial          
import struct
import time
import threading      #this is to ensure the working of the receiver and the transmitter code together
import sys

# COM port settings
ComPort = serial.Serial('COM8')  
ComPort.baudrate = 115200        
ComPort.bytesize = 8             
ComPort.parity   = 'N'           
ComPort.stopbits = 1             

N_RECEIVED_BYTES = 1
# Function - To send the data for encryption
def send_data():
    print("Enter a number (0-255) 8 Bits to send over UART to the board")
    print("The program will loop 16 times to send 128 Bits")
    
    for i in range(1, 17):  
        while True:  # Keep asking until a valid input is entered
            user_input = input(f"Iteration {i} DataArray_Index {i-1}: ")
            try:
                x = int(user_input)
                if 0 <= x <= 255:
                    ComPort.write(struct.pack('>B', x))  # Send data to FPGA
                    #print(f"Iteration {i}: Sent {x} over UART")
                    break  # Exit the inner loop if the input is valid
                else:
                    print("Error: Please enter a number between 0 and 255.")
            except ValueError:
                print("Error: Invalid input. Please enter a valid 8-bit number.")
        time.sleep(0.5)


# Function - To receive the decrypted data 
def receive_data():
    print("Receiving data from FPGA. ")
    while True:
        it = ComPort.read(N_RECEIVED_BYTES)  # For receiving data from FPGA
        print(f"Received data: {int.from_bytes(it, byteorder='big')}")

send_thread = threading.Thread(target=send_data)
receive_thread = threading.Thread(target=receive_data)

send_thread.start()
receive_thread.start()

send_thread.join()
receive_thread.join()

