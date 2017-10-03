package Markets::Domain::Factory::Entity::Category;
use Mojo::Base 'Markets::Domain::Factory';

sub cook {
    my $self = shift;

    # Aggregate children
    my $children = $self->param('children');
    if ( ref $children eq 'ARRAY' ) {
        $self->aggregate( children => 'entity-category', $children );
    }
}

1;
__END__

=head1 NAME

Markets::Domain::Factory::Entity::Category

=head1 SYNOPSIS

    my $entity = Markets::Domain::Factory::Entity::Category->new( %args )->create;

    # In controller
    my $entity = $c->factory('entity-category')->create(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Domain::Factory::Entity::Category> inherits all attributes from L<Markets::Domain::Factory> and implements
the following new ones.

=head1 METHODS

L<Markets::Domain::Factory::Entity::Category> inherits all methods from L<Markets::Domain::Factory> and implements
the following new ones.

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

 L<Markets::Domain::Factory>
