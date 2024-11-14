#!/usr/bin/env perl
use v5.34;
use warnings;
use utf8;
use open qw( :std :encoding(UTF-8) );

use File::Basename;

# This script updates the emoji picker script by replacing the list of emojis
# with the current list of all emojis taken from emojis.wiki.

my @CUSTOM = (
    '¯\_(ツ)_/¯: shrug kaomoji',
    '(╯°□°）╯︵ ┻━┻: table flip kaomoji',
    '(￣ー￣)ゞ: salute kaomoji',
    '\ʕ°□°ʔ/ bear kaomoji',
    '[ə́ə̀ə́]: dunno',
    '[ə̃́ə̃̀ə̃́]: dunno-nasal',
);

# download emoji list

my $raw = `curl -sLo- 'https://emojis.wiki/all-emojis/'`;
exit $? if ($?);

my @matches = $raw =~ m{<span\s+class="applyemojicard\d+">([^<]*)</span>\s*<span\s+class="applyemojicard\d+">([^<]*)<}g;
die "couldn't find emojis, maybe they've changed their website?" if (!@matches);
chomp @matches;

my @emojis;
while (@matches) {
    my $emoji = shift @matches;
    my $name = shift @matches;
    die 'somthing went wrong' if (!defined $emoji || !defined $name);
    die 'empty emoji' if (!length $emoji);
    die 'empty name' if (!length $name);
    die 'emoji breaks table format' if ($emoji =~ /: /);
    if ($name =~ /^Flag:(.*)/) {
        # keep the country names capitalised
        $name = "flag:$1";
    } else {
        $name = lc $name;
    }
    $name =~ s/&amp;/and/g;
    push @emojis, "$emoji: $name";
}

my $here = dirname __FILE__;
my $scriptfile = "$here/dmenu-emoji.pl";

open my $f, '<:encoding(UTF-8)', $scriptfile or die $!;
my @updatedscript;
my $echo = 1;
while (<$f>) {
    chomp;
    if (/<<'EMOJILIST'/) {
        $echo = 0;
        push @updatedscript, $_, @emojis, @CUSTOM;
    } elsif (/^EMOJILIST$/) {
        $echo = 1;
        push @updatedscript, $_;
    } elsif ($echo)  {
        push @updatedscript, $_;
    }
}
close $f;

open $f, '>:encoding(UTF-8)', $scriptfile or die $!;
say $f $_ foreach(@updatedscript);
close $f;
