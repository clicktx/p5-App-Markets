package Yetie::Domain::Entity::SalesItem;
use Moose;
use namespace::autoclean;

extends 'Yetie::Domain::Entity::CartItem';

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 NAME

Yetie::Domain::Entity::SalesItem

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::SalesItem> inherits all attributes from L<Yetie::Domain::Entity::CartItem>
and Implements the following new ones.

=head1 METHODS

L<Yetie::Domain::Entity::SalesItem> inherits all methods from L<Yetie::Domain::Entity::CartItem>
and Implements the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity::CartItem>, L<Yetie::Domain::Entity>
