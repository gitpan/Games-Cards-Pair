#!perl

use Games::Cards::Pair;

my $game = Games::Cards::Pair->new({debug => 0});
print "Game:\n$game\n\n";

do
{
    my $card1 = $game->draw();
    my $card2 = $game->draw($card1);
    $game->process($card1, $card2);
}
until ($game->is_over());

print "\n\nTotal moves [" . $game->count . "]\n";