package Yetie::Domain::Entity::CategoryTree;
use Yetie::Domain::Entity;

has children => sub { Yetie::Domain::Collection->new };

1;
__END__

=head1 NAME

Yetie::Domain::Entity::CategoryTree

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::CategoryTree> inherits all attributes from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 C<children>

Return L<Yetie::Domain::Collection> object.

=head1 METHODS

L<Yetie::Domain::Entity::CategoryTree> inherits all methods from L<Yetie::Domain::Entity> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity>
