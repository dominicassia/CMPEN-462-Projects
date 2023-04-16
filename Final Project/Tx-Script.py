#!/usr/bin/python
# Libraries
######################
from hashlib import sha512      # https://docs.python.org/3/library/hashlib.html
from Crypto.Cipher import AES
import RPi.GPIO as GPIO

######################
# Steps
######################

# Create LAN

# Preform key exchange


key = ''

# Init the speech to text

# Wait for button press
## Convert speech to text   

text = ''

# Compute & Append HMAC
hashh = sha512(text)
plaintext = text + hashh
plaintext_bytes = bytes(plaintext, 'utf-8')

iv = ''

# Encrypt text
cipher = AES.new(key, AES.MODE_CBC, iv)
ciphetext = cipher.encrypt(plaintext_bytes)

# Send over LAN

