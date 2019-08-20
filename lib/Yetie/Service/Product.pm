package Yetie::Service::Product;
use Mojo::Base 'Yetie::Service';

sub duplicate_product {
    my ( $self, $product_id ) = @_;

    my $entity = $self->find_product($product_id);
    return if !$entity->has_id;

    my $title = $entity->title . ' ' . $self->controller->__x_default_lang('copy');
    my $rs    = $self->resultset('Product');
    my $i     = $rs->search( { title => { like => $title . '%' } } )->count + 1;
    $entity->title( $title . $i );

    my $data = $entity->to_data;
    delete $data->{id};

    my $result = $rs->create($data);

    # Logging
    $self->logging_info( 'admin.product.duplicated', product_id => $product_id ) if $result;
    return $result;
}

sub find_product {
    my ( $self, $product_id ) = @_;

    my $result = $self->resultset('Product')->find_product($product_id);
    my $data = $result ? $result->to_data() : {};

    # tax rule
    my $tax_rule = $self->_get_tax_rule($result);
    $data->{tax_rule} = $tax_rule->to_data;

    my $product = $self->factory('entity-product')->construct($data);
    return $product;
}

sub is_sold {
    my ( $self, $product_id ) = @_;

    my $cnt = $self->resultset('SalesOrderItem')->search( { product_id => $product_id } )->count;
    return $cnt ? 1 : 0;
}

sub new_product {
    my $self = shift;

    my $title = $self->controller->__x_default_lang('New Product');
    my $rs    = $self->resultset('Product');
    my $i     = $rs->search( { title => { like => $title . '%' } } )->count;
    $title .= $i + 1;

    return $rs->create( { title => $title } );
}

# NOTE: 実際の動作がdelete相当となっている。method名変更するか論理削除にするか。
# [”delete”と”remove”の使い分けについて | SDNA ローカライズチームブログ](http://www.sonydna.com/sdna/solution/pr_loc/blog/20160511.html)
sub remove_product {
    my ( $self, $product_id ) = @_;

    my $product = $self->resultset('Product')->find($product_id);
    if ($product) {
        my $result = $product->delete;

        # Logging
        $self->logging_info( 'admin.product.removed', product_id => $product_id ) if $result;
        return $result;
    }
    return;
}

sub search_products {
    my ( $self, $form ) = @_;

    my $conditions = {
        where    => '',
        order_by => '',
        page_no  => $form->param('page') || 1,
        per_page => $form->param('per_page') || 5,
    };

    my $rs       = $self->resultset('Product')->search_products($conditions);
    my $data     = { list => $rs->to_data( { no_relation => 1 } ) };
    my $products = $self->factory('list-products')->construct($data);
    return ( $products, $rs->pager );
}

sub update_product_categories { return shift->resultset('Product')->update_product_categories(@_) }

sub update_product { return shift->resultset('Product')->update_product(@_) }

sub _get_tax_rule {
    my ( $self, $product ) = @_;

    # Category tax rule
    my $primary_category = $product->product_categories->get_primary_category;
    if ($primary_category) {
        my $category_tax_rule = $self->resultset('CategoryTaxRule')->find_now($primary_category);
        return $category_tax_rule->tax_rule if $category_tax_rule;
    }

    # Default tax rule
    my $default_tax_rule = $self->resultset('DefaultTaxRule')->find_now;
    return $default_tax_rule->tax_rule;
}

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

=head2 C<duplicate_product>

    my $result = $service->duplicate_product($product_id);

Duplicate from C<$product_id>.

Return L<Yetie::Schema::Result::Product> object or C<undefined>.

=head2 C<find_product>

    my $product = $service->find_product($product_id);

Return L<Yetie::Domain::Entity::Product> object.

=head2 C<is_sold>

    my $bool = $servece->is_sold($product_id);

Return boolean value.

=head2 C<new_product>

    my $result = $service->new_product();

Return L<Yetie::Schema::Result::Product> object.

=head2 C<remove_product>

    my $result = $service->remove_product($product_id);

Return L<Yetie::Schema::Result::Product> object or undefined.

=head2 C<search_products>

    my ( $product_list, $pager ) = $service->search_products($form);

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
