package Yetie::Service::Products;
use Mojo::Base 'Yetie::Service';

has resultset => sub { shift->schema->resultset('Product') };

sub search_products {
    my ( $self, $form ) = @_;

    my $conditions = {
        where    => '',
        order_by => '',
        page_no  => $form->param('page') || 1,
        per_page => $form->param('per_page') || 5,
    };

    my $products_rs = $self->resultset->search_products( $conditions );
    my $data = {
        meta_title   => '',
        breadcrumbs  => [],
        form         => $form,
        product_list => $products_rs->to_data( { no_relation => 1, no_breadcrumbs => 1 } ),
        pager        => $products_rs->pager,
    };
    return $self->factory('entity-products')->create($data);
}

1;
__END__

=head1 NAME

Yetie::Service::Products

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Service::Products> inherits all attributes from L<Yetie::Service> and implements
the following new ones.

=head1 METHODS

L<Yetie::Service::Products> inherits all methods from L<Yetie::Service> and implements
the following new ones.

=head2 C<search_products>

    my $entity = $service->search_products($form);

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Service>
