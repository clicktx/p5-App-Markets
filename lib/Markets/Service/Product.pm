package Markets::Service::Product;
use Mojo::Base 'Markets::Service';
use Try::Tiny;

has resultset => sub { shift->app->schema->resultset('product') };

sub create_entity {
    my ( $self, $product_id ) = @_;

    my $result = $self->resultset->search( { id => $product_id } );
    my $data = $result->hashref_first || {};
    return $self->app->factory('entity-product')->create($data);
}

1;
__END__

=head1 NAME

Markets::Service::Product

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Service::Product> inherits all attributes from L<Markets::Service> and implements
the following new ones.

=head1 METHODS

L<Markets::Service::Product> inherits all methods from L<Markets::Service> and implements
the following new ones.

=head2 C<create_entity>

    my $product = $app->service('product')->create_entity($product_id);

Return L<Markets::Domain::Entity::Product> object.

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

L<Markets::Service>
