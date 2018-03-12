package Yetie::Domain::Entity::CategoryTree;
use Yetie::Domain::Entity;

has level     => 0;
has root_id   => 0;
has title     => '';
has children  => sub { __PACKAGE__->collection };

sub has_child { @{ shift->children } ? 1 : 0 }

1;
__END__

=head1 NAME

Yetie::Domain::Entity::CategoryTree

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::CategoryTree> inherits all attributes from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 C<level>

=head2 C<root_id>

=head2 C<title>

=head2 C<children>

Return L<Yetie::Domain::Collection> object.

=head1 METHODS

L<Yetie::Domain::Entity::CategoryTree> inherits all methods from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 C<has_child>

    my $bool = $category_tree->has_child;

Return boolean value.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity>
