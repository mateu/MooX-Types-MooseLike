use strict;
use warnings FATAL => 'all';
use 5.008001;
use ExtUtils::MakeMaker;
(do 'maint/Makefile.PL.include' or die $@) unless -f 'META.yml';

my %RUN_DEPS = (
  'Moo' => 0.091006,
  'strictures' => 1.001001,
  'Module::Runtime' => 0.012,
);
my %BUILD_DEPS = (
  'Test::More' => 0.96,
  'Test::Fatal' => 0.003,
);

WriteMakefile(
  NAME => 'MooX-Types-MooseLike',
  VERSION_FROM => 'lib/MooX/Types/MooseLike.pm',
  PREREQ_PM => {
    %RUN_DEPS,
  },
  BUILD_REQUIRES => {
    %BUILD_DEPS,
  },
  META_ADD => {
    resources => {
      IRC         => 'irc://irc.perl.org/#web-simple',
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
  LICENSE => 'perl',
);
