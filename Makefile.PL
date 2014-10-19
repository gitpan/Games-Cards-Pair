use 5.006;
use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME               => 'Games::Cards::Pair',
    AUTHOR             => q{Mohammad S Anwar <mohammad.anwar@yahoo.com>},
    VERSION_FROM       => 'lib/Games/Cards/Pair.pm',
    ABSTRACT_FROM      => 'lib/Games/Cards/Pair.pm',
    LICENSE            => 'artistic_2',
    PL_FILES           => {},
    MIN_PERL_VERSION   => 5.006,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Test::More' => 0,
    },
    PREREQ_PM => {
        'Attribute::Memoize' => 1.01,
        'List::Util'         => 1.19,
        'List::MoreUtils'    => 0.33,
        'Moo'                => 0,
        'namespace::clean'   => 0,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'Games-Cards-Pair-*' },
    (eval { ExtUtils::MakeMaker->VERSION(6.46) } ? (META_MERGE => {
        'meta-spec' => { version => 2 },
        resources => {
            repository => {
                type => 'git',
                url  => 'https://github.com/Manwar/Games-Cards-Pair.git',
                web  => 'https://github.com/Manwar/Games-Cards-Pair',
            },
        }})
     : ()
    ),
);
