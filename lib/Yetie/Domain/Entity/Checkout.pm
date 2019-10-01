package Yetie::Domain::Entity::Checkout;
use Moose;
use namespace::autoclean;
extends 'Yetie::Domain::Entity';

has transaction => (
    is      => 'ro',
    default => sub { shift->factory('entity-transaction')->construct() },
);

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 NAME

Yetie::Domain::Entity::Checkout

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::Checkout> inherits all attributes from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 C<transaction>

    my $transaction = $checkout->transaction;

Return L<Yetie::Domain::Entity::Transaction> object.

=head1 METHODS

L<Yetie::Domain::Entity::Checkout> inherits all methods from L<Yetie::Domain::Entity> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity::Cart>, L<Yetie::Domain::Entity::Transaction>, L<Yetie::Domain::Entity>
