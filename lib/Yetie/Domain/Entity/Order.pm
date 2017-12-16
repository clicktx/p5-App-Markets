package Yetie::Domain::Entity::Order;
use Yetie::Domain::Entity;

has created_at      => undef;
has updated_at      => undef;
has customer        => sub { Yetie::Domain::Entity->new };
has billing_address => sub { Yetie::Domain::Entity->new };

1;
__END__

=head1 NAME

Yetie::Domain::Entity::Order

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::Order> inherits all attributes from L<Yetie::Domain::Entity> and implements
the following new ones.

=head1 METHODS

L<Yetie::Domain::Entity::Order> inherits all methods from L<Yetie::Domain::Entity> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity>
