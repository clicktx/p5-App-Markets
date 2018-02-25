package Yetie::Domain::Factory::CategoryTree::Node;
use Mojo::Base 'Yetie::Domain::Factory';

sub cook {
    my $self = shift;

    # Aggregate children
    my $children = $self->param('children');
    if ( ref $children eq 'ARRAY' ) {
        $self->aggregate_collection( children => 'entity-category_tree-node', $children );
    }
}

1;
__END__

=head1 NAME

Yetie::Domain::Factory::CategoryTree::Node

=head1 SYNOPSIS

    my $entity = Yetie::Domain::Factory::CategoryTree::Node->new( %args )->create;

    # In controller
    my $entity = $c->factory('entity-category_tree-node')->create(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Factory::CategoryTree::Node> inherits all attributes from L<Yetie::Domain::Factory> and implements
the following new ones.

=head1 METHODS

L<Yetie::Domain::Factory::CategoryTree::Node> inherits all methods from L<Yetie::Domain::Factory> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

 L<Yetie::Domain::Factory>
