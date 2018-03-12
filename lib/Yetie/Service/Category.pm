package Yetie::Service::Category;
use Mojo::Base 'Yetie::Service';

has resultset => sub { shift->schema->resultset('Category') };

sub find_category {
    my ( $self, $category_id, $form ) = @_;

    my $factory  = $self->factory('entity-category');
    my $category = $self->resultset->find($category_id);
    return $factory->create( {} ) unless $category;

    my $data = $category->to_data( { no_children => 1 } );
    $data->{form} = $form;

    # breadcrumbs
    $data->{breadcrumbs} = $category->to_breadcrumbs;

    # products
    my $page_no  = $form->param('page')     || 1;
    my $per_page = $form->param('per_page') || 3;
    my $products_rs = $category->search_products_in_categories( { page => $page_no, rows => $per_page } );
    $data->{products} = $products_rs;

    return $factory->create($data);
}

1;
__END__

=head1 NAME

Yetie::Service::Category

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Service::Category> inherits all attributes from L<Yetie::Service> and implements
the following new ones.

=head1 METHODS

L<Yetie::Service::Category> inherits all methods from L<Yetie::Service> and implements
the following new ones.

head2 C<find_category>

    my $entity = $service->find_category( $category_id, $form );

Return L<Yetie::Domain::Entity::Category> object.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Service>
