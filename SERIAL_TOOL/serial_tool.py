import serial
import socket
from threading import Thread

import struct

sock = socket.socket(socket.AF_INET,socket.SOCK_STREAM);
sock.bind(('localhost', 5000))
sock.listen(1)

conn, addr = sock.accept()

DATA = []

def recv_serial(port):
    ser = serial.Serial(port=port, baudrate=115200)

    while True:
        b = ser.read()
        if b[0] == 0:
            break
    print("zero recieved")
    count = 0
    while True:
        bytes_read = ser.read(323)
        MSB = []
        LSB = []
        checksum = 0x00
        checksumfromb = 0x00
        for i, b in enumerate(bytes_read):
            if i == 0:
                LSB1 = b
                checksum += int(b)
            elif i == 1:
                MSB1 = b
                checksum += int(b)
            elif i == 322:
                checksumfromb = b | 0x80
            else:
                if i % 2 == 0:
                    LSB.append(b)
                else:
                    MSB.append(b)
                checksum += int(b)

        if checksum // 256 >= 1:
            checksum = checksum % 256
        # if checksum == checksumfromb:
        DATA.append([ struct.pack('d',((MSB[i] & 0x7F) << 7) | (LSB[i] & 0x7F)) for i, M in enumerate(MSB)])

recv_serial_thread = Thread(target=recv_serial, args=["/dev/ttyACM0"])
recv_serial_thread.start()


while True:
    if not len(DATA) == 0:
        data = DATA.pop(0)
        del DATA[:]
        for b in data:
            conn.send(b)
