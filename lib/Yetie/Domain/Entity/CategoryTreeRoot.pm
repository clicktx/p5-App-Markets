package Yetie::Domain::Entity::CategoryTreeRoot;
use Moose;
use namespace::autoclean;
extends 'Yetie::Domain::Entity::CategoryTree';

has _index => ( is => 'rw', default => sub { {} } );

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 NAME

Yetie::Domain::Entity::CategoryTreeRoot

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::CategoryTreeRoot> inherits all attributes from L<Yetie::Domain::Entity::CategoryTree> and L<Yetie::Domain::Role::Category>.

implements the following new ones.

=head1 METHODS

L<Yetie::Domain::Entity::CategoryTreeRoot> inherits all methods from L<Yetie::Domain::Entity::CategoryTree> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity::CategoryTree>, L<Yetie::Domain::Role::Category>, L<Yetie::Domain::Entity>
