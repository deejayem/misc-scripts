#!/usr/bin/perl

# Much room for improvement in this code

use strict;
use warnings;

if (@ARGV != 1) {
    print "Usage: $0 <filename>\n";
    exit 2;
}

my $first = 1;
my $columns;
my $sql;

# We assume that the value of the DATA clob immediately follows the other data, giving us the right id
my $data_event_id=-1;

while(<>) {
    if (/\r\n$/) {
        print "Exiting: CRLF found\n";
        exit 2;
    }

    chomp;
    next if /^$/;

    if ($first) {
        $columns = $_;
        $first = 0;
        next;
    }

    my $values = "";
    my $sql = "";
    my $line = $_;

    if ($line !~ /^</) {
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

            # the first value is the data_event id, which we need to store to add
            # the data clob value
            if ($i == 1) {
                $data_event_id = $val;
            }

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
        $sql = "INSERT INTO data_events ($columns) VALUES ($values);\n\n";
    } else {
        # assume the previous data_event row was the one we need to update, based on id
        $sql = "UPDATE data_events SET data='$line' WHERE id=$data_event_id;\n\n";
    }

    print $sql;
}

0;

