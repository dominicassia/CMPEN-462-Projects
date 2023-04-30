#!/usr/bin/python

# References
# Sockets: https://docs.python.org/3/library/socket.html
# Crypto:  https://pycryptodome.readthedocs.io/en/latest/src/cipher/aes.html
# Hash:    https://docs.python.org/3/library/hashlib.html
# DH KeyE: https://cryptography.io/en/latest/hazmat/primitives/asymmetric/dh/

import socket
from hashlib import sha512
from Crypto.Cipher import AES
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.asymmetric import dh
from cryptography.hazmat.primitives.kdf.hkdf import HKDF
from cryptography.hazmat.primitives.serialization.Encoding import Encoding
import RPi.GPIO as GPIO

IP = "127.0.0.1"
PORT = 65432

PRINT = True    # Toggle print statements

def create_socket():
    ''' Creates and returns socket object '''

    if PRINT: print("Creating socket...\n") 

    # Create socket object: TCP, IPv4
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    # Bind socket to IP, Port
    s.bind((IP, PORT))

    return s

def server(socket):
    ''' Creates a server from given socket, listens for connecections and returns connection '''

    if PRINT: print("Listening for connection requests...\n")

    # Listen for connections
    socket.listen()

    # Blocks, waits for connection
    connection, address = socket.accept()

    if PRINT: print(f"Connected to: {address}\n")

    return connection

def key_exchange(connection):
    ''' Takes in socket and '''

    if PRINT: print("Performing key exhange...\n")

    # Diffie Hellman Parameters
    parameters = dh.generate_parameters(generator=2, key_size=2048)

    # Generate private, public key
    private_key = parameters.generate_private_key()
    public_key = private_key.public_key()

    # Send our public key
    connection.sendall( public_key.public_bytes(Encoding.PEM, ) )

    # Wait for clients public key
    client_public_key = connection.recv()

    # Convert clients public key from bytes


    key = ''

    # Create AES cipher object
    cipher = AES.new(key, AES.MODE_CBC)

    return cipher

def hash_encrypt(plaintext, cipher_obj):
    ''' Takes in plaintext and cipherobject, returns ciphertext '''

    # Take the hash
    hmac = sha512(plaintext)

    # Append to end of plaintext
    plaintext_hmac = plaintext + hmac

    # Convert to bytes
    plaintext_hmac_bytes = bytes(plaintext_hmac, 'utf-8')

    # Encrypt
    ciphertext = cipher_obj.encrypt(plaintext_hmac_bytes)

    return ciphertext



def main():

    if PRINT: print("Launching...\n")

    try:
        # Create socket object
        socket = create_socket()

        # Create server, wait for client
        connection = server(socket)
        
        # Preform key exchange
        cipher_obj = key_exchange(connection)

        # connection.sendall(msg)





    except Exception as e:
        print("==========\n{e}\n==========\n")

    # Close out
    if connection: connection.close()
    if socket: socket.close()
    
    return

if __name__ == "__main__":
    main()