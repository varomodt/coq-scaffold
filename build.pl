#!/usr/bin/env perl

use warnings;
use strict;
use Cwd 'abs_path';

my $cwd = abs_path($0);
$cwd =~ s/[^\/]+$//g;

# Rsync the sources into the object directory
chdir(qq($cwd));
system(qq(mkdir -p target));

if(-d "src") { system(qq(rsync -rt src/* target)); }
if(-d "lib") { system(qq(rsync -rt lib/* target)); }

chdir(qq(./target));

sub getInclude {
  my $dir = shift;
  my $dotdir = $dir;
  $dotdir =~ s/\//./ig;
  return " -R $dir $dotdir ";
}

my $load = join " ", (map { getInclude($_) } (split "\n", `find * -maxdepth 0 -type d`));
my $fileList = join " ", (split "\n", `find . | grep '\\.v\$'`);

# Generate the makefile with coq_makefile
print(qq(coq_makefile $fileList $load > Makefile.coq\n));
system(qq(coq_makefile $fileList $load > Makefile.coq));

# Build
system(qq(make -f Makefile.coq));

