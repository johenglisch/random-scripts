#!/usr/bin/env python3

import fileinput
import unicodedata


def name(c):
    if c == '\n':
        return 'LINE FEED'
    elif c == '\r':
        return 'CARRIAGE RETURN'
    elif c == '\t':
        return 'TABULATOR'
    else:
        return unicodedata.name(c, '???')


def main():
    for line in fileinput.input(openhook=fileinput.hook_encoded('utf-8')):
        print('\n'.join(map(name, line)))


if __name__ == '__main__':
    main()
