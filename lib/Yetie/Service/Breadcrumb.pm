package Yetie::Service::Breadcrumb;
use Mojo::Base 'Yetie::Service';

sub get_list_by_category_id {
    my ( $self, $category_id ) = @_;

    my $tree             = $self->service('category')->get_category_tree;
    my $current_category = $tree->get_node($category_id);
    return $self->factory('list-breadcrumbs')->construct( list => [] ) if !$current_category;

    # Ancestors category
    my @breadcrumbs;
    my $ancestors = $current_category->ancestors->list->reverse;
    $ancestors->each( sub { push @breadcrumbs, $self->_create_breadcrumb_by_category($_) } );

    # Current category
    push @breadcrumbs, $self->_create_breadcrumb_by_category( $current_category, { current => 1 } );

    return $self->factory('list-breadcrumbs')->construct( list => \@breadcrumbs );
}

sub get_list_by_product {
    my ( $self, $product ) = @_;

    my $primary_category = $product->product_categories->primary_category;
    my $primary_category_id = $primary_category ? $primary_category->id : undef;
    return $self->get_list_by_category_id($primary_category_id);
}

sub _create_breadcrumb_by_category {
    my ( $self, $category, $args ) = @_;

    my $breadcrumb = {
        title => $category->title,
        url   => $self->app->url_for( 'rn.category', category_id => $category->id ),
    };

    # Current category
    if ( $args->{current} ) { $breadcrumb->{class} = 'current' }

    return $breadcrumb;
}

1;
__END__

=head1 NAME

Yetie::Service::Breadcrumb

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Service::Breadcrumb> inherits all attributes from L<Yetie::Service> and implements
the following new ones.

=head1 METHODS

L<Yetie::Service::Breadcrumb> inherits all methods from L<Yetie::Service> and implements
the following new ones.

=head2 C<get_list_by_category_id>

    my $breadcrumb_list = $service->get_list_by_category_id($category_id);

Return L<Yetie::Domain::List::Breadcrumbs> object.

=head2 C<get_list_by_product>

    my $breadcrumb_list = $service->get_list_by_product($product_entity_obj);

Argument L<Yetie::Domain::Entity::Product> object.

Return L<Yetie::Domain::List::Breadcrumbs> object.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Service>
