#!/usr/bin/perl -w
use strict;
$|++;

my $envelope = <STDIN>;

use MIME::Parser;
use MIME::Entity;

my $parser = MIME::Parser->new;
$parser->output_to_core(1);
$parser->tmp_to_core(1);

my $ent = eval { $parser->parse(\*STDIN) }; die "$@" if $@;

if ($ent->effective_type eq "multipart/alternative"
    and $ent->parts == 2
    and $ent->parts(0)->effective_type eq "text/plain"
    and $ent->parts(1)->effective_type eq "text/html") {
  
  my $newent = MIME::Entity->build(Data =>
                                   $ent->parts(0)->body_as_string .
                                   "\n\n[[HTML alternate version delet
+ed]]\n");
  $ent->parts([$newent]);
  $ent->make_singlepart;
  $ent->sync_headers(Length => 'COMPUTE', Nonstandard => 'ERASE');
}

print $envelope;
$ent->print;

