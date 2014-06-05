use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  NAME         => 'Mojolicious::Plugin::GlobalEvents',
  VERSION_FROM => 'lib/Mojolicious/Plugin/GlobalEvents.pm',
  AUTHOR       => 'A Good Programmer <nospam@cpan.org>',
  PREREQ_PM    => {'Mojolicious' => '5.02'},
  test         => {TESTS => 't/*.t'}
);
