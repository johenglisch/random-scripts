#! /usr/bin/env python3


"""Convert tab-separated value files into an HTML table.

tsv data can be supplied via stdin or by supplying a number of tsv files
as command-line arguments.

Note: The script outputs the rows and cells of the table without any
surrounding <table> tabs."""


from fileinput import input


def main():
    for line in input():
        cells = line.split('\t')
        print('<tr>')
        for cell in cells:
            print('  <td>')
            print(' ', cell.strip())
            print('  </td>')
        print('</tr>')


if __name__ == '__main__':
    main()
