#!/usr/bin/env perl

use warnings;
use strict;
use Cwd 'abs_path';

my $cwd = abs_path($0);
$cwd =~ s/[^\/]+$//g;

sub getInclude {
  my $dir = shift;
  my $dotdir = $dir;
  $dotdir =~ s/\//./ig;
  return qq(-R target/$dir $dotdir);
}

my $load = join " ", (map { getInclude($_) } (
    split "\n", `bash -c 'cd target; find * -maxdepth 0 -type d'`));

system(qq(coqtop $load ) . join(' ', @ARGV));

