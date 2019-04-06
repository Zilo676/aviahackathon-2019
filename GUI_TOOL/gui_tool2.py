import sys
import getopt
import socket
import tkinter as tk
from tkinter import ttk
from threading import Thread
from time import sleep

from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg, NavigationToolbar2Tk
from matplotlib.figure import Figure
import matplotlib.animation as anim
import numpy as np

import struct


def f(A, n=8): 
    return [A[i:i+n] for i in range(0, len(A), n)]

def recieve(port):
    global socke
    if not socke:
        while True:
            try:
                sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                sock.connect(('127.0.0.1', port))
                socke = True
                break
            except:
                continue
    while True:
        data = []
        # recvdata = sock.recv(160)
        recvdata = f(sock.recv(160*8))
        sleep(0.05)
        print(recvdata)
        # recvdata = struct.unpack('d', recvdata)
        for r in recvdata:
            d = int(struct.unpack('d', r)[0])
            # d = r
            data.append(d)
            
        if len(data) == 160:
            DATA.append(data)


def animationplot(i):
    global current_y
    if not len(DATA) == 0:
        data = DATA.pop(0)
        del DATA[:]
        data = np.sin(2 * np.pi * 33) + data

        current_y = data.copy()
        print(current_y)

        plot.clear()
        plot.plot(t, data)
        # plot.draw()


class Touche(tk.Tk):
    def __init__(self, *args, **kwargs):
        tk.Tk.__init__(self, *args, **kwargs)
        tk.Tk.wm_title(self, "Touche GUI")
        tk.Tk.geometry(self, "800x900")

        # plot.plot(np.random.random([10, 1]))

        canvas = FigureCanvasTkAgg(main_figure, self)
        canvas.draw()
        canvas.get_tk_widget().pack(side=tk.BOTTOM, fill=tk.BOTH, expand=True)
        canvas._tkcanvas.pack(side=tk.TOP, fill=tk.BOTH, expand=True)


if __name__ == "__main__":
    argv = sys.argv[1:]

    # port = 8080
    port = 5000
    DATA = []

    t = np.arange(1, 161, 1)
    socke = False

    socke_com = False
    # init figure
    main_figure = Figure()
    plot = main_figure.add_subplot(1, 1, 1)

    root = Touche()

    recieve_thread = Thread(target=recieve, args=[port])
    recieve_thread.start()

    ani = anim.FuncAnimation(main_figure, animationplot, interval=10)

    root.mainloop()
