package Markets::Model::Cart;
use Mojo::Base 'Markets::Model';

use Mojo::Collection qw/c/;

sub items {
    my ( $self, $cart_data ) = @_;
    return if ref $cart_data ne 'HASH';

    # All items to Mojo::Collection
    my $items = $cart_data->{items} || [ [] ];
    my @data = map { c(@$_) } @{$items};
    return c(@data);
}

sub merge_cart {
    my ( $self, $cart_data, $stored_cart_data ) = ( shift, shift || {}, shift || {} );

    # Merge items
    my $items        = $self->items($cart_data);
    my $stored_items = $self->items($stored_cart_data);
    my $merged_items = _merge_items( $items, $stored_items );

    my $merged_cart->{items}->[0] = $merged_items;
    return $merged_cart;
}

sub _merge_items {
    my ( $items, $stored ) = @_;

    $items  = $items->flatten->to_array;
    $stored = $stored->flatten->to_array;

    my @items;
    foreach my $item ( @{$stored} ) {
        my $val = grep { $_->{product_id} eq $item->{product_id} } @{$items};

        # $item->{_stored_from} = 1;
        push @items, $item unless $val;
    }

    push @items, @{$items};
    return \@items;
}

1;
__END__

=head1 NAME

Markets::Model::Cart

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=head2 C<items>

    my $items = $c->model('cart')->items(\%cart_data);

Return L<Mojo::Collection> object.

=head2 C<merge_cart>

    my $merged_cart = $c->model('cart')->merge_cart(\%cart, \%stored_cart);

Return \%cart.

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

L<Markets::Model> L<Mojolicious::Plugin::Model> L<MojoX::Model>
