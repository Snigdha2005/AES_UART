
import serial           # import the module
import struct
import time

# Configure COM port settings
ComPort = serial.Serial('COM4')  # open COM4
ComPort.baudrate = 115200        # set Baud rate to 115200
ComPort.bytesize = 8             # Number of data bits = 8
ComPort.parity   = 'N'           # No parity
ComPort.stopbits = 1             # Number of Stop bits = 1

print("You will be prompted to enter 8-bit numbers (0-255) to send over UART.")
print("The program will loop 16 times with a 1-second gap between each send.")

# Loop to send data 16 times with 1-second delay
for i in range(1, 17):  # Loop from 1 to 16 for clearer iteration count in print
    user_input = input(f"Enter an 8-bit number (0-255) for iteration {i}: ")
    try:
        x = int(user_input)
        if 0 <= x <= 255:
            ComPort.write(struct.pack('>B', x))  # Send data to FPGA
            print(f"Iteration {i}: Sent {x} over UART")
        else:
            print("Error: Please enter a number between 0 and 255.")
            continue
    except ValueError:
        print("Error: Invalid input. Please enter a valid 8-bit number.")
        continue

    time.sleep(0.5)  # Wait 1 second between sends

ComPort.close()  # Close the Com port







# import serial           # import the module
# import struct
# import time

# ComPort = serial.Serial('COM4') # open COM24

# ComPort.baudrate = 115200 # set Baud rate to 9600
# ComPort.bytesize = 8    # Number of data bits = 8
# ComPort.parity   = 'N'  # No parity
# ComPort.stopbits = 1    # Number of Stop bits = 1

# print("Enter an 8-bit number")
# print("Press 'q' to exit infinite loop")

# x = 0

# while True:
#     x= x+1
#     if x == 256:
#         break
#     else:
#         ot = ComPort.write(struct.pack('>B', int(x)))    #for sending data to FPGA
#         print(f"Sent {x} over UART")

#     time.sleep(0.2)

# ComPort.close()         # Close the Com port

# import serial           # import the module
# import struct
# import time

# ComPort = serial.Serial('COM4')  # open COM4

# ComPort.baudrate = 115200  # set Baud rate to 115200
# ComPort.bytesize = 8       # Number of data bits = 8
# ComPort.parity   = 'N'     # No parity
# ComPort.stopbits = 1       # Number of Stop bits = 1

# print("You will be prompted to enter 8-bit numbers (0-255) to send over UART.")
# print("The program will loop 8 times with a 1-second gap between each send.")

# # Loop to send data 8 times with 1-second delay
# for _ in range(8):
#     user_input = input("Enter an 8-bit number (0-255): ")
#     try:
#         x = int(user_input)
#         if 0 <= x <= 255:
#             ot = ComPort.write(struct.pack('>B', x))  # Send data to FPGA
#             print(f"Sent {x} over UART")
#         else:
#             print("Error: Please enter a number between 0 and 255.")
#             continue
#     except ValueError:
#         print("Error: Invalid input. Please enter a valid 8-bit number.")
#         continue

#     time.sleep(1)  # Wait 1 second between sends

# ComPort.close()  # Close the Com port

# # 



# import serial           # import the module
# import struct
# import time
# import keyboard         # For detecting keypress

# # Configure COM port settings
# ComPort = serial.Serial('COM4')  # open COM4
# ComPort.baudrate = 115200        # set Baud rate to 115200
# ComPort.bytesize = 8             # Number of data bits = 8
# ComPort.parity   = 'N'           # No parity
# ComPort.stopbits = 1             # Number of Stop bits = 1

# print("You will be prompted to enter 8-bit numbers (0-255) to send over UART.")
# print("Press 'B' at any time to exit the program.")
# print("The program will loop 16 times with a 1-second gap between each send.")

# # Loop to send data 16 times with 1-second delay
# for i in range(1, 17):  # Loop from 1 to 16 for clearer iteration count in print
#     # Check if 'B' was pressed to exit the program
#     if keyboard.is_pressed('b'):
#         print("Program terminated by user.")
#         break
    
#     user_input = input(f"Enter an 8-bit number (0-255) for iteration {i}: ")
#     try:
#         x = int(user_input)
#         if 0 <= x <= 255:
#             ComPort.write(struct.pack('>B', x))  # Send data to FPGA
#             print(f"Iteration {i}: Sent {x} over UART")
#         else:
#             print("Error: Please enter a number between 0 and 255.")
#             continue
#     except ValueError:
#         print("Error: Invalid input. Please enter a valid 8-bit number.")
#         continue

#     time.sleep(0.5)  # Wait 1 second between sends

# ComPort.close()  # Close the COM port
