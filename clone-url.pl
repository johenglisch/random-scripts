#!/usr/bin/env perl
use v5.34;
use warnings;
use utf8;

if (@ARGV != 1) {
    say STDERR 'usage: clone-url url';
    exit 66;
}

my $url = $ARGV[0];
chomp $url;
my $repos_dir = $ENV{'REPOS_DIR'} || "$ENV{'HOME'}/repos";

if ($url !~ m|[:/]([^/]+)/([^/]+)$|) {
    say STDERR "Url must follow the pattern 'url/user/repo' or 'url:user/repo'";
    exit 1;
}

my $orgname = $1;
my $reponame = $2;

exec qw(git clone), $url, "$repos_dir/$orgname/$reponame";
