use strict;
use warnings FATAL => 'all';
use 5.008001;
use ExtUtils::MakeMaker;
(do 'maint/Makefile.PL.include' or die $@) unless -f 'META.yml';

WriteMakefile(
  NAME => 'MooX-Types-MooseLike',
  VERSION_FROM => 'lib/MooX/Types/MooseLike.pm',
  PREREQ_PM => {
    Moo => '0.009015',
  }
);
