#!perl -T

use Test::More tests => 2;

BEGIN {
    use_ok( 'Games::Cards::Pair' )       || print "Bail out!\n";
    use_ok( 'Games::Cards::Pair::Card' ) || print "Bail out!\n";
}