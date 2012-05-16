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
  META_ADD => {
    resources => {
      IRC         => 'irc://irc.perl.org/#moose',
      repository  => {
        url  => 'git://github.com/mateu/MooX-Types-MooseLike.git',
        web  => 'http://github.com/mateu/MooX-Types-MooseLike',
        type => 'git',
      },
      bugtracker  => {
        web    => 'http://rt.cpan.org/NoAuth/Bugs.html?Dist=MooX-Types-MooseLike',
        mailto => 'bug-MooX-Types-MooseLike@rt.cpan.org',
      },
    },
  },
);
