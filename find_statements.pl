#!/usr/bin/perl

use strict;
use warnings;
use POSIX qw(strftime);
use feature qw(say);

my $DEBUG=0;
my $INFO=0;

my $date = strftime "%d%m%Y", localtime;

my $client_refs = $ARGV[0];
(my $re = $client_refs) =~ s/,/|/g;
$re = '^CLNT,(' . $re . '),';
say "re: $re" if ($DEBUG or $INFO);

my $CS_START="CSHD";
my $CS_END="CSST";
my $CS_CLNT="CLNT";

my $cur_statement;
my $write_statement = 0;

for my $infile (<*.CSV>) {
    my $outfile = "new/$infile";
    $outfile =~ s/.CSV/_$date.CSV/;
    say "in: $infile" if ($DEBUG);
    say "out: $outfile" if ($DEBUG);
    #(my $outfile = $infile) =~ s/.csv/_1.csv/;
    open my $infh, '<', $infile or die "Could not open input file $infile: $!";
    open my $outfh, '>', $outfile or die "Could not open output file $outfile: $!";

    for my $line (<$infh>) {
        if ($line =~ m/^$CS_START/) {
            $cur_statement = $line;
            $write_statement = 0;
            say "Found start" if ($DEBUG);
        } else {
            $cur_statement .= $line;
            if ($line =~ m/^$CS_END/) {
                say "Found end" if ($DEBUG);
                print $outfh $cur_statement if ($write_statement);
            } elsif ($line =~ m/^$CS_CLNT/) {
                say "Found CLNT:" if ($DEBUG);
                print $line if ($DEBUG);
                if ($line =~ m/$re/) {
                    say "Matches" if ($DEBUG or $INFO);
                    print $line if ($INFO);
                    $write_statement = 1;
                }
            }
        }
    }

    close $infh;
    close $outfh if ($outfh);
}

0;

