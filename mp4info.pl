#!/usr/bin/perl

# requires MP4::Info - multimedia/p5-MP4-Info on FreeBSD, libmp3-info-perl on
# Debian, http://search.cpan.org/dist/MP4-Info
# requires Term::ReadKey (devel/p5-Term-ReadKey, libterm-readkey-perl)
# requires Perl 5.10 (or newer)

use strict;
use warnings;

# uncomment the following line and remove the use feature line if using
# Perl prior to 5.10
# say { print @_, "\n" }
use feature qw(say);

use MP4::Info;
use Term::ReadKey;

sub min { return $_[0] if($_[0]<$_[1]); $_[1] }

sub print_info {
    my ($filename,$wchar) = @_;
    my $info = get_mp4info $filename;
    my $tag = get_mp4tag $filename;

    my $first_line =  "Filename:  " . $filename;

    say $first_line;
    say "-" x min(length $first_line, $wchar);
    say "Length:    ", $info->{TIME}  || "Not available";
    say "Artist:    ", $tag->{ARTIST} || "Not available";
    say "Album:     ", $tag->{ALBUM}  || "Not available";
    say "Title:     ", $tag->{TITLE}  || "Not available";
    say "";
}


my @files = @ARGV;
my $wchar;
eval { ($wchar) = GetTerminalSize() }; $wchar = 80 if $@;
say "";
map { print_info $_, $wchar } @files;


