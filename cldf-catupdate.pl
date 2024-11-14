#!/usr/bin/env perl
use v5.34;
use warnings;
use utf8;

my $home = $ENV{'HOME'};
my $config = $ENV{'XDG_CONFIG_HOME'} || "$home/.config";
my $cat_file = "$config/cldf/catalog.ini";

if (! -f $cat_file) {
    say STDERR "$cat_file: file not found";
    exit 66;
}

open my $fh, '<', $cat_file or die $!;
my @lines = <$fh>;
close $fh;
@lines = grep /=/, @lines;
chomp @lines;

# cheekily add the glottolog cldf repo
push @lines, "glottolog-cldf = $home/repos/glottolog/glottolog-cldf";

sub cmpver {
    my $lhs = $_[0] =~ s/^v//r;
    my $rhs = $_[1] =~ s/^v//r;
    my @lhs = split /\./, $lhs;
    my @rhs = split /\./, $rhs;
    for (;;) {
        my $a = shift @lhs;
        my $b = shift @rhs;
        if (!defined($a) && (!defined($b))) {
            return 0;
        } elsif (!defined($a)) {
            return 1;
        } elsif (!defined($b)) {
            return -1;
        } elsif ($a != $b) {
            return $a <=> $b;
        }
    }
}

for my $line (@lines) {
    my ($name, $repo) = split /\s*=\s*/, $line, 2;
    system 'git', '-C', $repo, 'fetch';
    exit $? if ($?);

    my @tags = `git -C $repo tag`;
    exit $? if ($?);
    chomp @tags;
    # we don't switch to alphas and prereleases
    @tags = grep /^v?(\d+)(\.\d+)?(\.\d+)?$/, @tags;
    next if (scalar @tags == 0);

    @tags = sort { -&cmpver($a, $b) } @tags;
    say $repo;
    system 'git', '-C', $repo, 'checkout', $tags[0];
    exit $? if ($?);
}
