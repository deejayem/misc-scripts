#!/usr/bin/perl

use strict;
use warnings;

my $tab = ' 'x4;

my $xml_decl="<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>\n";

my $cl_start="<databaseChangeLog xmlns=\"http://www.liquibase.org/xml/ns/dbchangelog\" xmlns:ext=\"http://www.liquibase.org/xml/ns/dbchangelog-ext\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://www.liquibase.org/xml/ns/dbchangelog http://www.liquibase.org/xml/ns/dbchangelog/dbchangelog-3.3.xsd http://www.liquibase.org/xml/ns/dbchangelog-ext http://www.liquibase.org/xml/ns/dbchangelog/dbchangelog-ext.xsd\">\n";
my $cl_end="</databaseChangeLog>\n";

my $cs_start="${tab}<changeSet author=\"davidmo\" id=\"%s\">\n";
my $cs_end="${tab}</changeSet>\n";

my $insert_start=${tab}x2 . "<insert tableName=\"%s\">\n";
my $insert_end=${tab}x2 . "</insert>\n";

my $column=${tab}x3 . "<column name=\"%s\" value=\"%s\"/>\n";

my $time = time;

my ($table, $cols, $vals, $close) = (0,0,0,0);

my $id_idx = 0;

my @columns;
my @values;

my $filename = shift;
open my $fh, '>', $filename or die "Could not open $filename: $!";

print $fh $xml_decl . $cl_start;

while (<>)
{
    next if (/^\s*$/);
    next if (/^--/);

    chomp;
    s/^\s*//;
    s/\s*$//;
    s/\s+/ /g;
    s/['`)(]//g;

    if (/;/)
    {
        $close = 1;
        s/;//;
    }

    if (/insert into ([^ ]*)/)
    {
        $table = $1;
        $cols = 1;
    }
    elsif (/values/)
    {
        $vals = 1;
    }
    elsif ($cols and not $vals)
    {
        s/\s+//g;
        push @columns, (split /,/);
    }
    elsif ($vals)
    {
        s/\s+//g;
        push @values, (split /,/);
    }

    if ($close)
    {
        if ($table and @columns)
        {
            printf $fh $cs_start . $insert_start, ("insert-$table-$time-" . ++$id_idx, $table);
            for my $i (0 .. $#columns)
            {
                printf $fh $column, ($columns[$i], $values[$i]);
            }
            printf $fh $insert_end . $cs_end;
        }

        ($table, $cols, $vals, $close) = (0,0,0,0);
        undef @columns;
        undef @values;
    }

}

print $fh $cl_end;
close $fh;

0;

