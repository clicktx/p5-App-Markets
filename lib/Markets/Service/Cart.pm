package Markets::Service::Cart;
use Mojo::Base 'Markets::Service';

sub add_item {
    my $self = shift;

    my $params = $self->controller->req->params->to_hash;
    delete $params->{csrf_token};

    my $item = $self->controller->factory( 'entity-item', $params );
    return $self->controller->cart->add_item($item);
}

# sub clear { shift->controller->cart_session->flash(@_) }

sub cart_session_data { shift->controller->cart_session->data(@_) }

# sub has_items { shift->items->flatten->size ? 1 : 0 }
# sub has_items {
#     my $self = shift;
#     my $cart = $self->controller->cart;
#     $cart->items->size ? 1 : 0;
# }

# sub items { $_[0]->model('cart')->items( $_[0]->data ) }
# sub items {
#     my $self = shift;
#     my $cart = $self->controller->cart;
#     $cart->items;
# }

1;
__END__

=head1 NAME

Markets::Service::Cart

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Service::Cart> inherits all attributes from L<Markets::Service> and implements
the following new ones.

=head1 METHODS

=head2 C<add_item>

    $c->service('cart')->add_item( \%item );

Return entity cart object.

=head2 C<clear>

    # All data clear
    $c->service('cart')->clear;

    # Clear items data only
    $c->service('cart')->clear('items');

=head2 C<cart_session_data>

    my $data = $c->service('cart')->cart_session_data;
    $c->service('cart')->cart_session_data( fizz => buzz );

Alias for L<Markets::Session::CartSession/"data">.

=head2 C<has_items>

    my $bool = $c->service('cart')->has_items;

Return boolean value.

=head2 C<items>

    my $items = $c->service('cart')->items;

Get cart items.
Return L<Mojo::Collection> object.

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO
