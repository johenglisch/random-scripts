#!/usr/bin/env perl
use 5.016;
use warnings;
use strict;

my $cache_dir = $ENV{'XDG_CONFIG_HOME'} || ($ENV{'HOME'} . '/.config');
my $package_file = $cache_dir . '/pip-packages.txt';

# XXX: maybe allow for multiple packages on the same line? (space-separated)
open my $fptr, $package_file or die $!;
my @packages = <$fptr>;
close $fptr;
chomp @packages;
@packages = grep !/^\s*#|^\s*$/, @packages;

my @installed = `pip list --user`;
# get rid of the header
shift @installed;
shift @installed;
chomp @installed;
s/\s+.*// foreach (@installed);

say 'REMOVING the following packages:';
say join(' ', @installed);
say 'INSTALLING the following packages:';
say join(' ', @packages);

print 'Continue? [y|N] ';
my $answer = <STDIN>;
chomp $answer;
exit if ($answer ne 'y');

my $shell_result = 0;
if (scalar @installed != 0)
{
    $shell_result = system qw(pip uninstall --break-system-packages --yes), @installed;
}
if ($shell_result != 0)
{
    say 'something went wrong...';
    exit 1;
}

$shell_result = system qw(pip install --break-system-packages --ignore-installed --user -r), $package_file;
if ($shell_result != 0)
{
    say 'something went wrong...';
    exit 1;
}
