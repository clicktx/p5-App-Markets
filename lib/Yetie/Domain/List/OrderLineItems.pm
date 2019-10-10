package Yetie::Domain::List::OrderLineItems;
use Moose;
use namespace::autoclean;
extends 'Yetie::Domain::List::LineItems';

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 NAME

Yetie::Domain::List::OrderLineItems

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::List::OrderLineItems> inherits all attributes from L<Yetie::Domain::List::LineItems> and implements
the following new ones.

=head1 METHODS

L<Yetie::Domain::List::OrderLineItems> inherits all methods from L<Yetie::Domain::List::LineItems> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::List::LineItems>, L<Yetie::Domain::Entity::Item>, L<Yetie::Domain::List>
