#!/usr/bin/env python3

import tkinter as tk
from functools import partial
from tkinter import ttk
from urllib.parse import quote


def die(window, event):
    window.destroy()


def update_imglink(imglink, lenslink, *args):
    link = quote(imglink.get(), safe='')
    lenslink.set(f'https://lens.google.com/uploadbyurl?url={link}&safe=off')


def main():
    window = tk.Tk()
    window.title('use lens')
    window.columnconfigure(0, weight=1)
    window.rowconfigure(0, weight=1)
    window.bind('<Escape>', partial(die, window))

    frame = ttk.Frame(window, padding='5 5 5 5')
    frame.grid(column=0, row=0, sticky='nsew')
    frame.columnconfigure(0, weight=1)

    ttk.Label(frame, text='image link').grid(column=0, row=0, sticky='nw')
    ttk.Label(frame, text='lens link').grid(column=0, row=2, sticky='sw')

    imglink = tk.StringVar()
    imglink_entry = ttk.Entry(frame, textvariable=imglink)
    imglink_entry.grid(column=0, row=1, sticky='ew')
    lenslink = tk.StringVar()
    lenslink_entry = ttk.Entry(frame, textvariable=lenslink)
    lenslink_entry.grid(column=0, row=3, sticky='ew')
    imglink.trace_add('write', partial(update_imglink, imglink, lenslink))

    imglink_entry.focus()
    window.mainloop()


if __name__ == '__main__':
    main()
