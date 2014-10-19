use strict; use warnings;
use Games::Cards::Pair;
use Test::More tests => 5;

my ($game, $card);
$game = Games::Cards::Pair->new;
is($game->is_over, 0);

$game = Games::Cards::Pair->new;
$card = $game->draw();
ok($card);

eval { Games::Cards::Pair->new({ debug => 'a' }) };
like($@, qr/isa check for "debug" failed/);

eval { Games::Cards::Pair->new({ debug => 2 }) };
like($@, qr/isa check for "debug" failed/);

eval { $game->draw($game) };
like($@, qr/ERROR: Invalid card received/);