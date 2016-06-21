#! /usr/bin/env python3


import fileinput
import sys


TABLEAU = '''\\begin{{tabular}}[t]{{|l@{{\\ }}l@{{\\ }}l||*{{{count}}}{{l|}}}}
  \hline
  I: & & {input} & {constraints} \\\\\\hline\\hline
{candidates}
\\end{{tabular}}'''

CANDIDATE = '  {label}. & {hand} & {output} & {violations} \\\\\\hline'


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


def format_candidates(candidates, violations, optimal):
    for lineno, profile in enumerate(violations):
        yield CANDIDATE.format(
            label=chr(ord('a') + lineno),
            hand='\\ding{43}' if profile == optimal else '',
            output=candidates[lineno],
            violations=' & '.join('{$*$}' * n for n in profile))


def main():
    lines = filter(lambda s: not s.isspace(), fileinput.input())
    header = split_row(next(lines))
    input = header[0]
    constraints = header[1:]

    candidates = list()
    violations = list()
    optimal = None
    for row in split_lines(lines, len(constraints) + 1):
        profile = list(map(force_int, row[1:]))

        candidates.append(row[0])
        violations.append(profile)

        if optimal is None:
            optimal = profile
        else:
            optimal = min(optimal, profile)

    print(TABLEAU.format(
        input=input,
        count=len(constraints),
        constraints=' & '.join(constraints),
        candidates='\n'.join(
            format_candidates(candidates, violations, optimal))))

    return 0


if __name__ == '__main__':
    sys.exit(main())
