#!/usr/bin/env perl
use v5.34;
use warnings;
use utf8;

# I developed a habit of creating sort of a time stamp file whenever I stop
# watching a video midway through to do something else, e.g.:
#  * `video-name.mp4`
#  * `video-name-1h23m`
# This script looks for the time stamp file and resumes mpv playback right at
# that time stamp.

if (scalar @ARGV != 1) {
    say STDERR 'usage: mpv-continue prefix';
    exit 64;
}

my $prefix = shift @ARGV;

# escape glob patterns
$prefix =~ s/([\[\]*{}])/\\$1/g;
my @files = glob "'$prefix*'";
if (scalar @files == 1 && $files[0] =~ /\.(?:mkv|mp4|webm)$/) {
    system 'mpv', $files[0];
    exit $?>>8;
} elsif (scalar @files != 2) {
    say STDERR "there must be two files starting with $prefix";
    exit 1;
}

my $videofile;
my $mpvstamp;
foreach (@files) {
    if (/-(?:0*(\d+)h)?(?:0*(\d+)m)?(?:0*(\d+)s)?$/) {
        my $hrs = $1 || 0;
        my $min = $2 || 0;
        my $sec = $3 || 0;
        $mpvstamp = sprintf '%02d:%02d:%02d', $hrs, $min, $sec;
    } elsif (/\.(?:mkv|mp4|webm)$/) {
        $videofile = $_;
    } else {
        say STDERR "$_: what is this file?";
        exit 1;
    }
}

if (!defined $videofile) {
    say STDERR 'could not determine video file';
    exit 1;
}
if (!defined $mpvstamp) {
    say STDERR 'could not determine time stamp';
    exit 1;
}

system 'mpv', $videofile, "--start=$mpvstamp";
exit $?>>8 if ($?);
