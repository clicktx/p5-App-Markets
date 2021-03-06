package Yetie::Factory::Entity::CategoryTreeRoot;
use Mojo::Base 'Yetie::Factory';

sub cook {
    my $self = shift;

    $self->aggregate( children  => 'list-category_trees', $self->param('children')  || [] );
}

1;
__END__

=head1 NAME

Yetie::Factory::Entity::CategoryTreeRoot

=head1 SYNOPSIS

    my $entity = Yetie::Factory::Entity::CategoryTreeRoot->new( %args )->construct();

    # In controller
    my $entity = $c->factory('entity-category_tree_root')->construct(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Factory::Entity::CategoryTreeRoot> inherits all attributes from L<Yetie::Factory> and implements
the following new ones.

=head1 METHODS

L<Yetie::Factory::Entity::CategoryTreeRoot> inherits all methods from L<Yetie::Factory> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Factory>
