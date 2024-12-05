#!/usr/bin/env perl
use 5.016;
use warnings;
use strict;

my $cache_dir = $ENV{'XDG_CONFIG_HOME'} || "$ENV{'HOME'}/.config";
my $package_file = "$cache_dir/pip-packages.txt";

open my $fh, '<', $package_file or die $!;
my @packages = <$fh>;
close $fh;
chomp @packages;
@packages = grep !/^\s*#|^\s*$/, @packages;

my @installed = `pip list --user`;
exit $?>>8 if ($?);
# get rid of the table header
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

if (scalar @installed != 0) {
    system qw(pip uninstall --break-system-packages --yes), @installed;
    exit $?>>8 if ($?);
}

system qw(pip install --break-system-packages --ignore-installed --user -r), $package_file;
exit $?>>8 if ($?);
