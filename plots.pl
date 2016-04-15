#!/usr/bin/perl
use strict;
use warnings;

# lots of room for improvement here

$ENV{TZ}="Europe/London";

-e "data" or die "No data/ directory!";
-e "scripts" or mkdir "scripts" or die "Couldn't mkdir scripts: $!";
-e "plots" or mkdir "plots" or die "Couldn't mkdir plots: $!";

my $start="set autoscale\n" .
          "unset log\n" .
          "unset label\n" .
          "set terminal png\n" .
          "set key below\n" .
          "set xtics auto\n" .
          "set ytics auto\n";

# graph name is key, values are references to arrays containing the column and title
my %graphs = (
               num      => [1, "Number of processes"],
               total    => [2, "Total size of all apache processes/kB"],
               largest  => [3, "Size of largest process/kB"],
               smallest => [4, "Size of the smallest process/kB"],
               mean     => [5, "Mean process size/kB"],
             );

# lazy!
# csv to tab separated values
system('cd data ; for i in httpd_processes_* ; do tr \',\' \'\t\' < ${i} > tab_${i} ; done');

my $plot_string="plot ";

chdir "data";
for (<httpd_p*>) { 
    my ($time) = /(\d+)/;
    my $date=scalar localtime $time;
    $plot_string .= "\"data/tab_$_\" using _N_ title \"$date\" w points ps 1 pt _M_, ";
    #$plot_string .= "\"data/tab_$_\" using _N_ title \"$date\" w lines, ";
}
chdir "..";

# we could check for when we're in the last iteration of the loop, but we're
# lazy and it makes things messier, to just add it then remove it
$plot_string =~ s/, $//;

# some of gnuplots point types are annoying, so redefine the order
my @pointers = (1,2,6,8,4,7,9,5,3);
my $index = 0;
while ($plot_string =~ s/_M_/$pointers[$index]/) {
    $index = ($index + 1)%@pointers
}

for my $graph (keys %graphs) {
    open my $fh, '>', "scripts/$graph.p" or die "Couldn't open $graph.p: $!";
    print $fh $start;
    print $fh "set ylabel '$graphs{$graph}[1]\n";
    print $fh "set output 'plots/$graph.png'\n";

    # fill in the column
    (my $str = $plot_string) =~ s/_N_/$graphs{$graph}[0]/g;
    print $fh $str;
    close $fh;
}

system "gnuplot scripts/*.p";
unlink "<data/tab_*>";
