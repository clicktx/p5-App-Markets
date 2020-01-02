package Yetie::Domain::Entity::PaymentMethod;
use Moose;
use namespace::autoclean;
extends 'Yetie::Domain::Entity';

has name => (
    is  => 'ro',
    isa => 'Str',
);

# description
# surcharge 支払い手数料  x% + x円
# surcharge_title
# instructions
# logo url alt

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 NAME

Yetie::Domain::Entity::PaymentMethod

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::PaymentMethod> inherits all attributes from L<Yetie::Domain::Entity> and implements
the following new ones.

=head1 METHODS

L<Yetie::Domain::Entity::PaymentMethod> inherits all methods from L<Yetie::Domain::Entity> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity>
