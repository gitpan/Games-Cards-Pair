use 5.006;
use strict; use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'Games::Cards::Pair',
    AUTHOR        => q{Mohammad S Anwar <mohammad.anwar@yahoo.com>},
    VERSION_FROM  => 'lib/Games/Cards/Pair.pm',
    ABSTRACT_FROM => 'lib/Games/Cards/Pair.pm',
    dist          => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean         => { FILES => 'Games-Cards-Pair-*' },
    PREREQ_PM     => {
        'Module::Build'      => 0.40,
        'Test::More'         => 0,
        'Attribute::Memoize' => 1.01,
        'List::Util'         => 1.19,
        'List::MoreUtils'    => 0.33,
        'Mouse'              => 0.93,
        'Readonly'           => 1.03,
    },
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
);