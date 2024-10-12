#!/usr/bin/env perl
use v5.34;
use warnings;
use utf8;

use IPC::Open2;

my $CACHEDIR = $ENV{'XDG_CACHE_HOME'} || "$ENV{'HOME'}/.cache";
# TODO: make customisable?
my $HISTFILE = "$CACHEDIR/fuzzy-cd-history";

if (!@ARGV) {
    say STDERR 'Where to?';
    exit 64;
}
my $query = shift @ARGV;

my @folders = `locate -b -- "$query"`;
exit $? if ($?);
chomp @folders;
@folders = grep { -d && !m|/\.| } @folders;

my %history;
if (-f $HISTFILE) {
    open my $fh, '<', $HISTFILE or die $!;
    while (<$fh>) {
        chomp;
        my ($dirname, $count) = split /\t/;
        $history{$dirname} = $count;
    }
    close $fh;
}

@folders = sort { ($history{$b} || 0) <=> ($history{$a} || 0) } @folders;

my $fzf = open2 my $fzfrdr, my $fzfwtr, qw(fzf -1 --reverse --height=20 --no-sort);
say $fzfwtr join("\n", @folders);
close $fzfwtr;
my $answer = <$fzfrdr>;
close $fzfrdr;
waitpid $fzf, 0;
exit $? if ($?);
exit 1 if (!defined $answer || $answer eq '' || $answer eq "\n");
chomp $answer;

my $old_count = $history{$answer} || 0;
$history{$answer} = $old_count + 1;

# i like my cache files to be as stable as feasible
my @hist_folders = sort { $history{$b} <=> $history{$a} } keys(%history);

open my $fh, '>', $HISTFILE or die $!;
for my $folder (@hist_folders) {
    say $fh "$folder\t$history{$folder}";
}
close $fh;

say $answer;
