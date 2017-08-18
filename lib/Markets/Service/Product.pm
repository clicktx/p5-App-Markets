package Markets::Service::Product;
use Mojo::Base 'Markets::Service';

sub create_entity {
    my ( $self, $product_id ) = @_;

    # Sort primary category is first
    my $data = $self->schema->resultset('Product')->search( { 'me.id' => $product_id },
        { order_by => { -desc => 'is_primary' }, prefetch => { categories => 'detail' } } )->hashref_first;

    # Ancestors(Primary category path)
    my $primary_category = $data->{categories}->[0];
    my $ancestors        = [];
    if ($primary_category) {
        $ancestors =
          $self->schema->resultset('Category')->find( $primary_category->{category_id} )->ancestors->hashref_array;
        @{$ancestors} = reverse @{$ancestors};
        push @{$ancestors}, $primary_category->{detail};
    }
    $data->{ancestors} = $ancestors;

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
