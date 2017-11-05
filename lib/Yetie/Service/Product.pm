package Yetie::Service::Product;
use Mojo::Base 'Yetie::Service';

has resultset => sub { shift->schema->resultset('Product') };

sub choices_primary_category {
    my ( $self, $entity ) = @_;

    my @categories;
    $entity->product_categories->each(
        sub {
            my $ancestors = $self->schema->resultset('Category')->get_ancestors_arrayref( $_->id );
            my $title;
            foreach my $ancestor ( @{$ancestors} ) { $title .= $ancestor->{title} . ' > ' }
            $title .= $_->title;
            push @categories, [ $title, $_->category_id, choiced => $_->is_primary ];
        }
    );
    return wantarray ? @categories : \@categories;
}

sub duplicate_product {
    my ( $self, $product_id ) = @_;

    my $entity = $self->controller->factory('product')->build($product_id);
    my $title  = $entity->title . ' ' . $self->controller->__x_default_lang('copy');
    my $i      = $self->resultset->search( { title => { like => $title . '%' } } )->count + 1;
    $entity->title( $title . $i );

    my $data = $entity->to_data;
    delete $data->{primary_category};

    my $result = $self->resultset->create($data);

    # Logging
    $self->app->admin_log->info( 'Duplicate product from ID:' . $product_id ) if $result;

    return $result;
}

sub new_product {
    my $self = shift;

    my $title = $self->controller->__x_default_lang('New Product');
    my $i = $self->resultset->search( { title => { like => $title . '%' } } )->count;
    $title .= $i + 1;

    return $self->resultset->create( { title => $title } );
}

sub remove_product {
    my ( $self, $product_id ) = @_;

    my $product = $self->resultset->find($product_id);
    if ($product) {
        my $result = $product->delete;

        # Logging
        $self->app->admin_log->info( 'Removed product ID:' . $product_id ) if $result;

        return $result;
    }
    return;
}

sub update_product_categories { shift->resultset->update_product_categories(@_) }

sub update_product { shift->resultset->update_product(@_) }

1;
__END__

=head1 NAME

Yetie::Service::Product

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Service::Product> inherits all attributes from L<Yetie::Service> and implements
the following new ones.

=head1 METHODS

L<Yetie::Service::Product> inherits all methods from L<Yetie::Service> and implements
the following new ones.

=head2 C<choices_primary_category>

    my $product_categories = $service->choices_primary_category($entity);
    my @product_categories = $service->choices_primary_category($entity);

Argument: L<Yetie::Domain::Entity::Product> object.

Return: Array ou Array refference.

=head2 C<duplicate_product>

    my $result = $service->duplicate_product($product_id);

Duplicate from C<$product_id>.

Return L<Yetie::Schema::Result::Product> object.

=head2 C<new_product>

    my $result = $service->new_product();

Return L<Yetie::Schema::Result::Product> object.

=head2 C<remove_product>

    my $result = $service->remove_product($product_id);

Return L<Yetie::Schema::Result::Product> object or undefined.

=head2 C<update_product_categories>

    $servece->update_product_categories( $product_id, \@category_ids, $primary_category_id );

See L<Yetie::Schema::ResultSet::Product/update_product_categories>

=head2 C<update_product>

    $servece->update_product( $product_id, \%from_parameters );

See L<Yetie::Schema::ResultSet::Product/update_product>

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Service>
