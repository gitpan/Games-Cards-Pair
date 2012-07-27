use 5.006;
use strict; use warnings;
use Module::Build;

my $builder = Module::Build->new(
    sign                => 1,
    module_name         => 'Games::Cards::Pair',
    license             => 'perl',
    dist_author         => q{Mohammad S Anwar <mohammad.anwar@yahoo.com>},
    dist_version_from   => 'lib/Games/Cards/Pair.pm',
    add_to_cleanup     => [ 'Games-Cards-Pair-*' ],
    configure_requires => { 'Module::Build' => 0.40 },
    build_requires     => {
        'Test::More'         => 0,
        'Attribute::Memoize' => 1.01,
        'List::Util'         => 1.19,
        'List::MoreUtils'    => 0.33,
        'Mouse'              => 0.93,
        'Readonly'           => 1.03,
    },
);

$builder->create_build_script();