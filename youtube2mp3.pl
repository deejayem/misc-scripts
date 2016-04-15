#!/usr/bin/perl

use strict;
use warnings;

printf("Usage: youtube2mp3.pl url outputfile artist title\n") and exit unless $#ARGV == 3;

my ($mp3_file, $artist, $title) = @ARGV[1..3];

$mp3_file = $mp3_file . ".mp3" unless $mp3_file =~ /\.mp3$/;

(my $wav_file = $mp3_file) =~ s/.mp3$/.wav/;
#open(URL, "youtube-dl -g $ARGV[0] |");
#my $url = <URL>;
my $url = `youtube-dl -g $ARGV[0]`;
system("mplayer", "-really-quiet", "-vo", "null", "-ao", "pcm:waveheader:fast:file=$wav_file", "$url");

# mplayer uses , as a separator
$wav_file  =~ s/,/\\,/g;
system( "lame", # "--quiet",
        "-h", "-b", "160",
        "--tt", "$title",
        "--ta", "$artist",
        "$wav_file", "$mp3_file"
        );

unlink $wav_file;

