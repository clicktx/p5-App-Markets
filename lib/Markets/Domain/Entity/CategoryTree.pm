package Markets::Domain::Entity::CategoryTree;
use Markets::Domain::Entity;
use Markets::Domain::Collection;

has children => sub { Markets::Domain::Collection->new };

1;
__END__

=head1 NAME

Markets::Domain::Entity::CategoryTree

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Domain::Entity::CategoryTree> inherits all attributes from L<Markets::Domain::Entity> and implements
the following new ones.

=head2 C<children>

Return L<Markets::Domain::Collection> object.

=head1 METHODS

L<Markets::Domain::Entity::CategoryTree> inherits all methods from L<Markets::Domain::Entity> and implements
the following new ones.

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

L<Markets::Domain::Entity>
