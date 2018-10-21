package Yetie::Service::Category;
use Mojo::Base 'Yetie::Service::Base';

sub find_category_with_products { shift->_find_category( @_, 1 ) }

sub find_category { shift->_find_category( @_, undef ) }

sub _find_category {
    my ( $self, $category_id, $form, $with_products ) = @_;
    my $category = $self->resultset('Category')->find($category_id);
    return $self->factory('entity-page-category')->construct( {} ) unless $category;

    my $products_rs = $with_products ? _append_products( $form, $category ) : undef;
    my $data = _to_data( $form, $category, $products_rs );
    return $self->factory('entity-page-category')->construct($data);
}

sub _append_products {
    my ( $form, $category ) = @_;

    # TODO: デバッグ用なので削除する
    my $page_no  = $form->param('page')     || 1;
    my $per_page = $form->param('per_page') || 3;

    return $category->search_products_in_categories( { page => $page_no, rows => $per_page } );
}

sub _to_data {
    my ( $form, $category, $products_rs ) = @_;

    my $data = $category->to_data( { no_children => 1 } );
    $data->{form}        = $form;
    $data->{breadcrumbs} = $category->to_breadcrumbs;
    return $data unless $products_rs;

    # with products
    $data->{products} = $products_rs->to_data( { no_datetime => 1, no_relation => 1, no_breadcrumbs => 1 } );
    $data->{pager} = $products_rs->pager;
    return $data;
}

1;
__END__

=head1 NAME

Yetie::Service::Category

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Service::Category> inherits all attributes from L<Yetie::Service::Base> and implements
the following new ones.

=head1 METHODS

L<Yetie::Service::Category> inherits all methods from L<Yetie::Service::Base> and implements
the following new ones.

=head2 C<find_category_with_products>

    my $entity = $service->find_category_with_products( $category_id, $form );

Return L<Yetie::Domain::Entity::Page::Category> object.

The attribute "products" has a list of products.

=head2 C<find_category>

    my $entity = $service->find_category( $category_id, $form );

Return L<Yetie::Domain::Entity::Page::Category> object.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Service::Base>
