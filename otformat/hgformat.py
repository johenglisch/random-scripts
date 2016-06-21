#! /usr/bin/env python3


import fileinput
import sys

import numpy as np


TABLEAU = '''\\begin{{tabular}}[t]{{|l@{{\\ }}l@{{\\ }}l||r||*{{{count}}}{{r|}}}}
  \hline
  I: & & {input} & $H$ & {constraints} \\\\
  & & & & {weights} \\\\\\hline\\hline
{candidates}
\\end{{tabular}}'''

CANDIDATE = '  {label}. & {hand} & {output} & {harmony} & {satisfaction} \\\\\\hline'


def split_row(line, width=None):
    row = [s.strip() for s in line.split('|')]
    if width is not None and len(row) != width:
        raise ValueError('Rows have different numbers of columns')
    return row


def split_lines(lines, width):
    return (split_row(l, width) for l in lines)


def force_int(s):
    try:
        return int(s)
    except ValueError:
        return 0


def format_candidates(candidates, satisfaction, harmonies, optimal):
    for lineno, profile in enumerate(satisfaction):
        yield CANDIDATE.format(
            label=chr(ord('a') + lineno),
            hand='\\ding{43}' if harmonies[lineno] == optimal else '',
            harmony=harmonies[lineno],
            output=candidates[lineno],
            satisfaction=' & '.join(map(str, profile)))


def main():
    lines = filter(lambda s: not s.isspace(), fileinput.input())
    header1 = split_row(next(lines))
    width = len(header1)
    input = header1[0]
    constraints = header1[1:]

    header2 = split_row(next(lines), width)
    weights = np.array(list(map(force_int, header2[1:])))

    candidates = list()
    cells = list()
    for row in split_lines(lines, width):
        candidates.append(row[0])
        cells.append(list(map(force_int, row[1:])))

    satisfaction = np.array(cells)
    harmonies = np.dot(satisfaction, weights)
    optimal = harmonies.max()

    print(TABLEAU.format(
        input=input,
        count=len(constraints),
        constraints=' & '.join(constraints),
        weights=' & '.join(map(str, weights)),
        candidates='\n'.join(
            format_candidates(candidates, satisfaction, harmonies, optimal))))

    return 0


if __name__ == '__main__':
    sys.exit(main())
