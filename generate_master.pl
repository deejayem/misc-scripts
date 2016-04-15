#!/usr/bin/perl

use strict;
use warnings;

my $tab = ' 'x4;

my $xml_decl="<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>\n";

my $cl_start="<databaseChangeLog xmlns=\"http://www.liquibase.org/xml/ns/dbchangelog\" xmlns:ext=\"http://www.liquibase.org/xml/ns/dbchangelog-ext\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://www.liquibase.org/xml/ns/dbchangelog http://www.liquibase.org/xml/ns/dbchangelog/dbchangelog-3.3.xsd http://www.liquibase.org/xml/ns/dbchangelog-ext http://www.liquibase.org/xml/ns/dbchangelog/dbchangelog-ext.xsd\">\n";
my $cl_end="</databaseChangeLog>\n";

my $include="${tab}<include file=\"%s\"/>\n";

my $filename = 'db.changelog-master.xml';
open my $fh, '>', $filename or die "Could not open $filename: $!";

print $fh $xml_decl . $cl_start;

for (<db.changelog-[0-9]*.xml>)
{
    printf $fh $include, ($_);
}

print $fh $cl_end;
close $fh;

0;

