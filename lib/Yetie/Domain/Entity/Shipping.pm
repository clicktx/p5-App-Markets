package Yetie::Domain::Entity::Shipping;
use Moose;
use namespace::autoclean;
extends 'Yetie::Domain::Entity';

with 'Yetie::Domain::Role::Tax';

has fee => (
    is      => 'ro',
    isa     => 'Yetie::Domain::Value::Price',
    default => sub { __PACKAGE__->factory('value-price')->construct() },
);


no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 NAME

Yetie::Domain::Entity::Shipping

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::Shipping> inherits all attributes from L<Yetie::Domain::Entity> and L<Yetie::Domain::Role::Tax>.

Implements the following new ones.

=head2 C<fee>

Return L<Yetie::Domain::Value::Price> object.

=head2 C<tax_rule>

Inherits from L<Yetie::Domain::Role::Tax>

=head1 METHODS

L<Yetie::Domain::Entity::Shipping> inherits all methods from L<Yetie::Domain::Entity> and L<Yetie::Domain::Role::Tax>.

Implements the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Role::Tax>, L<Yetie::Domain::Entity>
