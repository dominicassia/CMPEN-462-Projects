#!/usr/bin/python

import socket

IP = "127.0.0.1"
PORT = 6000

PRINT = True    # Toggle print statements

############################################

def send(comm_obj, data):
    
    if PRINT: print(f'Sending... {data}\n')

    # Encode
    data_bytes = bytes(data, 'utf-8')

    # Send
    comm_obj.sendall(data_bytes)

    return

def receive(comm_obj):

    if PRINT: print(f'Receiving...\n')

    # Continually attempt to receive
    while True:
        
        # Recieve
        data_bytes = comm_obj.recv(2048)

        # If rx not null
        if data_bytes:

            # Decode
            data = str(data_bytes)
            
            return data

def main(comm_obj):

    pass

def setup_comm():

    try:
        if PRINT: print("Creating socket...\n")

        # Create socket object: TCP, IPv4
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:

            if PRINT: print("Connecting...\n")

            # Connect
            s.connect((IP, PORT))

            # Call main
            main(s)


    except Exception as e:
        print(f"==========\n{e}\n==========\n")
    
    return

############################################

# On file call
if __name__ == "__main__":

    if PRINT: print("Launching...\n")
    
    setup_comm()
