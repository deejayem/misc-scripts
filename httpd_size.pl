#!/usr/bin/perl
use warnings;
use strict;
use IO::Handle;
use List::Util qw(sum);

$ENV{TZ}="Europe/London";

sub cdr { shift;@_ }
sub mean { sum(@_)/@_ }
sub standard_deviation { sqrt( mean( map { $_ ** 2 } @_ ) - (mean @_) ** 2 ) }
sub get_london_time { sprintf "%.2d:%.2d", (localtime time)[2,1] }

my $time_to_run = $ARGV[0] || 0; # seconds (0 means we'll just run through once)
my $sleep_time = $ARGV[1] || 300; # seconds
my $stoptime = time + $time_to_run;

my $filename = "httpd_processes_" . time . ".txt";
open my $fh, '>', $filename or die "Unable to open $filename: $!";
$fh->autoload(1);

$SIG{INT} = \&handle_INT;
my $interrupted;
sub handle_INT { $interrupted = 1 }

while (1) {
    s/^\s*// for (my @sizes = cdr `ps -C httpd -o sz`);
    @sizes = sort { $b <=> $a } @sizes;

    my $num = @sizes;
    my $total = sum @sizes;
    my $mean = mean @sizes;
    my $sd = standard_deviation @sizes;
    my ($largest,$smallest) = @sizes[0,-1];

    # number of processes, total memory/kB, largest/kB,
    # smallest/kB, mean/kB, standard deviation, time in London
    my $csv = sprintf "%d,%d,%d,%d,%d,%d,%s\n", $num,$total,$largest,$smallest,$mean,$sd,get_london_time;
    print $fh $csv;

    # do the check before sleeping; one too many is better than one too few
    last if time >= $stoptime or $interrupted;
    sleep $sleep_time;
}

close $fh;
