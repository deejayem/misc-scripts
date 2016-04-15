#!/usr/bin/perl

# Much room for improvement in this code

use strict;
use warnings;

if (@ARGV != 2) {
    print "Usage: $0 <tablename> <filename>\n";
    exit 2;
}

my $tablename = shift;

my $first = 1;
my $columns;
my $sql;

while(<>) {
    if (/\r\n$/) {
        print "Exiting: CRLF found\n";
        exit 2;
    }

    chomp;

    if ($first) {
        $columns = $_;
        # remove "s
        $columns =~ tr/"//d;
        $first = 0;
        next;
    }

    my $values = "";
    my $line = $_;

    my $i = 1;
    my @vs = split /,/,$line;
    for my $val (@vs) {
        # remove "s first
        $val =~ s/^"|"$//g;
        ## then whitespace
        #$val =~ s/^\s*|\s*$//g;

        # no value -> NULL
        if ($val =~ /^$/) {
            $val = "NULL";
        # date -> add TO_DATE call
        } elsif ($val =~ /^[0-3][0-9]\/[0-1][0-9]\/(19|20)[0-9]{2}$/) {
            $val = "TO_DATE('$val','dd/mm/yyyy')";
        # datetime -> add TO_DATE call
        } elsif ($val =~ /^[0-3][0-9]\/[0-1][0-9]\/(19|20)[0-9]{2} [0-2][0-9](:[0-6][0-9]){2}$/) {
            $val = "TO_DATE('$val','dd/mm/yyyy hh24:mi:ss')";
        # string/varchar -> add 's
        } elsif ($val !~ /^-?[0-9]+(\.[0-9]+)?$/) {
            $val = "'$val'";
        }
        # otherwise it's a number -> nothing to do

        # add a , if it's not the last one
        if (++$i <= @vs) {
            $val .= ",";
        }

        $values .= $val;
    }

    # if the last column(s) is(/are) empty, we add an extra nulls
    if ($line =~ /(?<tail>,+)$/) {
        for (my $i = 0; $i < ($+{tail} =~ tr/,//); $i++) {
            $values .= ",NULL";
        }
    }

    #print "line: ", $line, "\n";
    #print $columns, "\n";
    #print "values: ", $values, "\n";
    my $sql = "INSERT INTO $tablename ($columns) VALUES ($values);\n\n";
    print $sql;
    #last;
}

0;

