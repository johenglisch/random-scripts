#!/usr/bin/env perl
use v5.34;
use warnings;
use utf8;

use IPC::Open2 qw(open2);

# TODO: implement cli args to change these
my $speed = 175;
my $voice = 'en-uk-north';

if (@ARGV != 1) {
    say STDERR 'usage: readout <file>';
    exit 64;
}
my $file = $ARGV[0];

my @lines;
if ($file eq '-') {
    @lines = <STDIN>;
} else {
    open my $fptr, '<', $file or die $!;
    @lines = <$fptr>;
    close $fptr;
}

# strip comments
@lines = grep !/^%/, @lines;
my $texcode = join '', @lines;
$texcode =~ s/([^\\](:?\\\\)*)%.*?\n/$1/g;

# strip preamble if available
$texcode =~ s/[\s\S]*\\begin\{document\}//g;
$texcode =~ s/\\end\{document\}[\s\S]*$//g;

# make some commands more espeakable
$texcode =~ s/\\citep?\{[^}]*\}//g;
$texcode =~ s/\\(?:NN?ext|LL?ast)\b/The Example/g;
$texcode =~ s/\\(?:sub)*section\*?\{([^}]*)\}/$1.\n\n/g;
$texcode =~ s/\\ref\{[^}]*\}/X/g;

# collapse paragraphs into single lines.
$texcode =~ s/\r//g;
$texcode =~ s/[\t ]+\n[\t ]+/\n/g;
$texcode =~ s/\n\n+\n/\n\n/g;
$texcode =~ s/([^\n])\n([^\n])/$1 $2/g;

my $detex_pid = open2 my $detex_out, my $detex_in, qw(detex -cl -e), 'array,figure,table,tikzpicture'
    or die $!;
print $detex_in $texcode;
close $detex_in;
my @plaintext = <$detex_out>;
close $detex_out;
waitpid $detex_pid, 0;
chomp @plaintext;

for my $line (@plaintext) {
    next if ($line =~ /^\s*$/);
    say $line;
    # open my $espeak_in, '–|', qw(espeak -p30), "-s$speed", "-v$voice" or die $!;
    open my $espeak_in, "| espeak -p30 '-s$speed' '-v$voice'" or die $!;
    say $espeak_in $line;
    close $espeak_in;
    exit $?>>8 if ($?);
}
