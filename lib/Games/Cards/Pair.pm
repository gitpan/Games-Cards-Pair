package Games::Cards::Pair;

use 5.006;
use strict; use warnings;

use overload ( '""'  => \&as_string );
use Carp;
use Mouse;
use Mouse::Util::TypeConstraints;

use Games::Cards::Pair::Card;
use Data::Dumper;
use Attribute::Memoize;
use List::Util qw(shuffle);
use List::MoreUtils qw/first_index/;

=head1 NAME

Games::Cards::Pair - Interface to the Pelmanism (Pair) Card Game.

=head1 VERSION

Version 0.02

=cut

our $VERSION = '0.02';

type 'ZeroOrOne' => where { /^[1|0]$/ };

has 'bank'      => (is => 'rw', isa => 'ArrayRef[Games::Cards::Pair::Card]');
has 'seen'      => (is => 'rw', isa => 'ArrayRef[Games::Cards::Pair::Card]');
has 'board'     => (is => 'rw', isa => 'HashRef');
has 'available' => (is => 'ro', isa => 'ArrayRef');
has 'count'     => (is => 'rw', isa => 'Int',       default => 0);
has 'debug'     => (is => 'rw', isa => 'ZeroOrOne', default => 0);

=head1 DESCRIPTION

A single-player game of Pelmanism, played by the program, as of now but very soon I would make
it an interactive game so that human can also play with it.
A pack of cards comprises each of the  thirteen values ( 2, 3, 4, 6, 7, 8, 9, 10, Queen, King,
Ace, Jack ) in each of the four suits ( Clubs, Diamonds, Hearts, Spades ) plus two jokers. The
Joker will not have any suit.

=cut

sub BUILD
{
    my $self  = shift;
    my $cards = [];

    foreach my $suit ('Clubs', 'Diamonds', 'Hearts', 'Spades')
    {
        foreach my $value ('Ace','2','3','4','5','6','7','8','9','10','Jack','Queen','King')
        {
            push @$cards, Games::Cards::Pair::Card->new({ suit => $suit, value => $value });
        }
    }

    # Adding two Jokers to the Suit.
    push @$cards, Games::Cards::Pair::Card->new({ value => 'Joker' });
    push @$cards, Games::Cards::Pair::Card->new({ value => 'Joker' });
    push @{$self->{available}}, $_ for (0..53);

    # Index card after shuffle.
    $self->_index($cards);
}

=head1 METHODS

=head2 draw()

Returns  a  card  randomly  selected from the deck or undef if it is empty. If previously seen
similar  value  card  then  returns that card. There are two flavours of this method, if it is
called without any parameter then it simply returns the randomly picked card from the deck.And
it if it's called passing a card then  it checks   whether we have seen any similar value card
before or not.If yes then it picks that card and made the match otherwise picks another random
card from the deck.

    use strict; use warnings;
    use Games::Cards::Pair;

    my $game = Games::Cards::Pair->new();
    my $card = $game->draw();
    print "Card picked: $card\n";

=cut

sub draw
{
    my $self = shift;
    my $card = shift;

    $self->{count}++;
    if (not defined $card)
    {
        $card = $self->_draw();
        print "Card 1 picked $card.\n" if $self->debug;
        return $card;
    }

    croak("ERROR: Invalid card received.\n")
        unless (ref($card) eq 'Games::Cards::Pair::Card');

    my $new = $self->_seen($card);
    if (defined $new)
    {
        print "Card 2 picked previously seen $new.\n" if $self->debug;
        return $new;
    }

    $new = $self->_draw();
    if (defined $new)
    {
        push @{$self->{seen}}, $new;
        print "Card 2 picked $new.\n" if $self->debug;
    }
    return $new;
}

=head2 process()

Check if the two given cards are the same and act accordingly.

    use strict; use warnings;
    use Games::Cards::Pair;

    my ($game, $card1, $card2);
    $game  = Games::Cards::Pair->new();
    $card1 = $game->draw();
    $card2 = $game->draw($card1);
    $game->process($card1, $card2);

=cut

sub process
{
    my $self = shift;
    my $card = shift;
    my $new  = shift;

    if ($new->equal($card))
    {
        $self->_process($new, $card);
    }
    else
    {
        $self->{deck}->{$new->index}  = $new;
        $self->{deck}->{$card->index} = $card;
    }

    ($self->debug) && (print "$self\n" && sleep 1);
}

=head2 is_over()

Returns 1 or 0 depending if the deck is empty or not.

    use strict; use warnings;
    use Games::Cards::Pair;

    my $game = Games::Cards::Pair->new();
    print "Game is not over yet.\n" unless $game->is_over;

=cut

sub is_over
{
    my $self = shift;
    return 1 if (scalar(@{$self->{available}}) == 0);
    return 0;
}

=head2 as_string()

Returns deck arranged as 6 x 9 blocks. This is overloaded as string context.

    use strict; use warnings;
    use Games::Cards::Pair;

    my $game = Games::Cards::Pair->new();
    print $game->as_string() . "\n";
    print "Is same as before:\n $game\n";

=cut

sub as_string
{
    my $self = shift;

    my $deck = '';
    foreach my $i (1..54)
    {
        my $card = $self->{deck}->{$i-1};
        $deck .= sprintf("[ %s ] ", defined($card)?'C':' ');
        $deck .= "\n" if ($i % 9 == 0);
    }
    return $deck;
}

=head2 get_matched_pairs()

Returns all the matching pair, if any found, from the bank.

    use strict; use warnings;
    use Games::Cards::Pair;

    my $game = Games::Cards::Pair->new();
    do
    {
        my $card1 = $game->draw();
        my $card2 = $game->draw($card1);
        $game->process($card1, $card2);
    }
    until ($game->is_over());

    print "Matched cards:\n" . $game->get_matched_pairs();

=cut

sub get_matched_pairs
{
    my $self   = shift;
    my $string = '';
    foreach (@{$self->{bank}})
    {
        $string .= sprintf("%s %s\n", $_->[0], $_->[1]);
    }
    return $string;
}

sub _save
{
    my $self  = shift;
    my @cards = @_;
    croak("ERROR: Expecting atleast a pair of cards.\n")
        unless (scalar(@cards) == 2);

    push @{$self->{bank}}, [@cards];
}

sub _process
{
    my $self = shift;
    my $card = shift;
    my $new  = shift;

    print "MATCHED !!!!!!!!!!!\n" if $self->debug;
    $self->{deck}->{$new->index}  = undef;
    $self->{deck}->{$card->index} = undef;
    $self->_save($card, $new);

    my $index = first_index { $_ == $new->index } @{$self->{available}};
    splice(@{$self->{available}}, $index, 1)
        if ($index != -1);

    $index = first_index { $_ == $card->index } @{$self->{available}};
    splice(@{$self->{available}}, $index, 1)
        if ($index != -1);
}

sub _index
{
    my $self  = shift;
    my $cards = shift;

    $cards = [shuffle @{$cards}];
    my $index  = 0;
    foreach my $card (@{$cards})
    {
        $card->index($index);
        $self->{deck}->{$index} = $card;
        $index++;
    }
}

sub _draw
{
    my $self   = shift;
    my @random = shuffle(@{$self->{available}});
    my $index  = shift @random;
    return $self->{deck}->{$index}
        if defined $index;
    return;
}

sub _seen :Memoize
{
    my $self = shift;
    my $card = shift;

    my $index = 0;
    foreach (@{$self->{seen}})
    {
        if ($card->equal($_))
        {
            splice(@{$self->{seen}}, $index, 1);
            return $_;
        }
        $index++;
    }
    return;
}

=head1 AUTHOR

Mohammad S Anwar, C<< <mohammad.anwar at yahoo.com> >>

=head1 BUGS

Please report any bugs / feature requests to C<bug-games-cards-pair at rt.cpan.org> or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Games-Cards-Pair>.I will
be notified & then you'll automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Games::Cards::Pair

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Games-Cards-Pair>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Games-Cards-Pair>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Games-Cards-Pair>

=item * Search CPAN

L<http://search.cpan.org/dist/Games-Cards-Pair/>

=back

=head1 LICENSE AND COPYRIGHT

Copyright 2012 Mohammad S Anwar.

This  program  is  free software;  you can redistribute it and/or modify it under the terms of
either:  the  GNU  General Public License as published by the Free Software Foundation; or the
Artistic License.

See http://dev.perl.org/licenses/ for more information.

=head1 DISCLAIMER

This  program  is  distributed  in  the hope that it will be useful, but WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

=cut

__PACKAGE__->meta->make_immutable;
no Mouse;
no Mouse::Util::TypeConstraints;

1; # End of Games::Cards::Pair
