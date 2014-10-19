package Games::Cards::Pair::Card;

$Games::Cards::Pair::Card::VERSION = '0.05';

=head1 NAME

Games::Cards::Pair::Card - Object representation of a card.

=head1 VERSION

Version 0.05

=cut

use 5.006;
use Data::Dumper;
use overload ( '""'  => \&as_string );
use Games::Cards::Pair::Params qw($Num $Value $Suit);

use Moo;
use namespace::clean;

has 'index' => (is => 'rw', isa => $Num );
has 'suit'  => (is => 'ro', isa => $Suit);
has 'value' => (is => 'ro', isa => $Value, required => 1);

=head1 DESCRIPTION

Only for internal use of Games::Cards::Pair class. Avoid using it directly.

=cut

sub BUILDARGS {
    my ($class, $args) = @_;

    if (defined($args->{'value'}) && ($args->{'value'} =~ /Joker/i)) {
        die("Attribute (suit) is NOT required for Joker.") if defined $args->{'suit'};
    }
    else {
        die("Attribute (suit) is required.") unless defined $args->{'suit'};
    }

    return $args;
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

sub equal {
    my ($self, $other) = @_;

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

sub as_string {
    my ($self) = @_;

    return sprintf("[%s of %s]", $self->value, $self->suit) if defined $self->suit;

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

Copyright 2012 - 2014 Mohammad S Anwar.

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
