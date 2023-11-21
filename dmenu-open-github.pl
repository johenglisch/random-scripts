#!/usr/bin/env perl
use v5.30;
use warnings;
use utf8;

use IPC::Open2;


sub run_command
{
    my ($command, $input) = @_;
    open2 \*PIPE_OUT, \*PIPE_IN, $command or die $!;
    say PIPE_IN $input;
    close PIPE_IN;
    my $answer = <PIPE_OUT>;
    close PIPE_OUT;
    if (defined $answer)
    {
        chomp $answer;
        $answer;
    }
    else
    {
        '';
    }
}


my $cache_dir = $ENV{'XDG_CACHE_HOME'} || glob('~/.cache');
my $history_file = "$cache_dir/github-links.txt";

open FILE, $history_file;
my @repo_strings = <FILE>;
close FILE;

my %history;

chomp @repo_strings;
foreach my $line (@repo_strings)
{
    my ($orga, $repo) = split '/', $line;
    push @{$history{$orga}}, $repo;
}

my $command = 'dmenu';
my $orgas_string = join "\n", sort(keys(%history));
my $orga = &run_command('dmenu -p orga', $orgas_string);
exit if ($orga eq '');

my @repos;
if (defined $history{$orga})
{
    @repos = @{$history{$orga}};
}
else
{
    @repos = ();
}

my $repos_string = join "\n", sort(@repos);
my $repo = &run_command('dmenu -p repo', $repos_string);
exit if ($repo eq '');

# unknown repos are added to the history file
unless (
    defined $history{$orga}
    && grep(/^\Q$repo\E$/, @{$history{$orga}}))
{
    open FILE, '>>', $history_file;
    say FILE "$orga/$repo";
    close FILE;
}

system 'xdg-open', "https://github.com/$orga/$repo";
