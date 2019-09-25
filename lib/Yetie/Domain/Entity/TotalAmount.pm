package Yetie::Domain::Entity::TotalAmount;
use Moose;
use namespace::autoclean;
extends 'Yetie::Domain::Entity';

has tax_rate => (
    is      => 'ro',
    default => 0,
);
has tax => (
    is  => 'ro',
    isa => 'Yetie::Domain::Value::Tax',
);
has total_excl_tax => (
    is  => 'ro',
    isa => 'Yetie::Domain::Value::Price',
);
has total_incl_tax => (
    is  => 'ro',
    isa => 'Yetie::Domain::Value::Price',
);

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 NAME

Yetie::Domain::Entity::TotalAmount

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::TotalAmount> inherits all attributes from L<Yetie::Domain::Entity> and implements
the following new ones.

=head1 METHODS

L<Yetie::Domain::Entity::TotalAmount> inherits all methods from L<Yetie::Domain::Entity> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity>
