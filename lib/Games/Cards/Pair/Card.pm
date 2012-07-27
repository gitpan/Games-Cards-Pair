package Games::Cards::Pair::Card;

use 5.006;
use strict; use warnings;

use Carp;
use Mouse;
use Mouse::Util::TypeConstraints;

use overload ( '""'  => \&as_string );
use Readonly;

=head1 NAME

Games::Cards::Pair::Card - Object representation of a card.

=head1 VERSION

Version 0.02

=cut

our $VERSION = '0.02';

Readonly my $SUITS => { 'Clubs' => 1, 'Diamonds' => 1, 'Hearts' => 1, 'Spades' => 1 };

Readonly my $VALUES => { '2'   => 1, '3'    => 1, '4'     => 1, '5'    => 1, '6'     => 1,
                         '7'   => 1, '8'    => 1, '9'     => 1, '10'   => 1,
                         'Ace' => 1, 'Jack' => 1, 'Queen' => 1, 'King' => 1, 'Joker' => 1 };

type 'Suits'  => where { exists $SUITS->{ucfirst(lc($_))} };
type 'Values' => where { exists $VALUES->{ucfirst(lc($_))} };

has 'suit'  => (is => 'ro', isa => 'Suits',  required => 0);
has 'value' => (is => 'ro', isa => 'Values', required => 1);
has 'index' => (is => 'rw', isa => 'Int',    required => 0);

=head1 DESCRIPTION

Only for internal use of Games::Cards::Pair class. Avoid using it directly.

=cut

around BUILDARGS => sub
{
    my $orig  = shift;
    my $class = shift;

    if (defined($_[0]->{value}) && ($_[0]->{value} =~ /Joker/i)) {
        croak("Attribute (suit) is NOT required for Joker.")
            if defined $_[0]->{suit};
    }
    else
    {
        croak("Attribute (suit) is required.")
            unless defined $_[0]->{suit};
    }
    return $class->$orig(@_);
};

=head1 METHODS

=head2 equal()

Returns 1 or 0 depending whether the two cards are same in value or one of them is a Joker.

    use strict; use warnings;
    use Games::Cards::Pair::Card;

    my ($card1, $card2);
    $card1 = Games::Cards::Pair::Card->new({ suit => 'Clubs',    value => '2' });
    $card2 = Games::Cards::Pair::Card->new({ suit => 'Diamonds', value => '2' });
    print "Card are the same.\n" if $card1->equal($card2);

    $card2 = Games::Cards::Pair::Card->new({ value => 'Joker' });
    print "Card are the same.\n" if $card1->equal($card2);

=cut

sub equal
{
    my $self  = shift;
    my $other = shift;

    return 0 unless (defined($other) && (ref($other) eq 'Games::Cards::Pair::Card'));

    return 1
        if ((defined($self->{value}) && ($self->{value} =~ /Joker/i))
            ||
            (defined($other->{value}) && ($other->{value} =~ /Joker/i))
            ||
            (defined($self->{value}) && (defined($other->{value}) && (lc($self->{value}) eq lc($other->{value})))));

    return 0;
}

=head2 as_string()

Returns the card object in readable format. This is overloaded as string context for printing.

    use strict; use warnings;
    use Games::Cards::Pair::Card;

    my $card = Games::Cards::Pair::Card->new({ suit => 'Clubs', value => '2' });
    print "Card: $card\n";
    # or
    print "Card: " . $card->as_string() . "\n";

=cut

sub as_string
{
    my $self = shift;
    return sprintf("[%s of %s]", $self->value, $self->suit)
        if defined $self->suit;

    return sprintf("[%s]", $self->value);
}

=head1 AUTHOR

Mohammad S Anwar, C<< <mohammad.anwar at yahoo.com> >>

=head1 BUGS

Please report any bugs / feature requests to C<bug-games-cards-pair at rt.cpan.org>,or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Games-Cards-Pair>.I will
be notified, & then you'll automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Games::Cards::Pair::Card

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

1; # End of Games::Cards::Pair::Card