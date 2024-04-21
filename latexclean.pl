#!/usr/bin/env perl
use v5.34;
use warnings;
use utf8;

my @texfiles;
if (scalar @ARGV > 0) {
    @texfiles = @ARGV;
} else {
    @texfiles = glob '"*.tex"';
}

my @exts = qw(
    adx aux bbl bcf blg fdb_latexmk fls idx ilg ind ldx log mw nav out run.xml
    sdx snm toc xdv);

for my $texfile (@texfiles) {
    my $root = $texfile =~ s/\.tex$//r;
    for my $ext (@exts) {
        my $auxpath = "$root.$ext";
        if (-f $auxpath) {
            system 'rm', '-v', $auxpath;
        }
    }
}
