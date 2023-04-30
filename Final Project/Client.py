#!/usr/bin/python

import socket                                   # https://docs.python.org/3/library/socket.html
from Crypto.Cipher import AES                   # https://pycryptodome.readthedocs.io/en/latest/src/cipher/classic.html#cbc-mode
from Crypto.Util.Padding import pad, unpad
from base64 import b64encode, b64decode
import json

IP = "127.0.0.1"
PORT = 6000

PRINT = True    # Toggle print statements

KEY_SIZE = 16   # 16, 24, or 32 bytes
KEY = b'CMPEN 462'
padded_key = pad(KEY, KEY_SIZE)

############################################

def send(comm_obj, data):
    
    if PRINT: print(f'Sending... {data}\n')

    # Encode
    if type(data) != bytes:
        data_bytes = bytes(data, 'utf-8')
    else:
        data_bytes = data

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
            return data_bytes

def encrypt(data, key):

    # Encode
    if type(data) != bytes:
        data_bytes = bytes(data, 'utf-8')
    else:
        data_bytes = data

    # Pad
    padded_data_bytes = pad(data_bytes, AES.block_size)

    # Create AES cipher object
    cipher_obj = AES.new(key, AES.MODE_CBC)

    # Encrypt
    ciphertext_bytes = cipher_obj.encrypt(padded_data_bytes)

    # Encode
    encoded_ciphertext = b64encode(ciphertext_bytes).decode('utf-8')
    encoded_iv = b64encode(cipher_obj.iv).decode('utf-8')

    # Pack
    package = {}
    package['iv'] = encoded_iv
    package['ciphertext'] = encoded_ciphertext
    json_package = json.dumps(package)

    return json_package

def decrypt(json_package, key):

    # Unpack
    package = json.loads(json_package)
    encoded_ciphertext = package['ciphertext']
    encoded_iv = package['iv']

    # Decode
    ciphertext_bytes = b64decode(encoded_ciphertext)
    iv = b64decode(encoded_iv)

    # Create cipher obj
    cipher_obj = AES.new(key, AES.MODE_CBC, iv)

    # Decrypt
    padded_plaintext_bytes = cipher_obj.decrypt(ciphertext_bytes)

    # Unpad
    plaintext_bytes = unpad(padded_plaintext_bytes, AES.block_size)

    return plaintext_bytes

def main(comm_obj):

    #### Send to server

    data = 'Hello from client'

    json_package = encrypt(data, padded_key)

    send(comm_obj, json_package)

    #### Receive from servers

    json_package = receive(comm_obj)

    data = decrypt(json_package, padded_key)

    print(f'{data}\n')

def setup_comm():

    # try:
    if PRINT: print("Creating socket...\n")

    # Create socket object: TCP, IPv4
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:

        if PRINT: print("Connecting...\n")

        # Connect
        s.connect((IP, PORT))

        # Call main
        main(s)

    # except Exception as e:
    #     print(f"==========\n{e}\n==========\n")
    
    return

############################################

# On file call
if __name__ == "__main__":

    if PRINT: print("Launching *client*...\n")
    
    setup_comm()

'''
    data = 'Hello'
    send(comm_obj, data)
'''
'''
    data = 'Hello'
    ciphertext_bytes = encrypt(cipher_obj, data)
    send(comm_obj, ciphertext_bytes)
'''
