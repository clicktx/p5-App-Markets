package Markets::Controller::Catalog::Product;
use Mojo::Base 'Markets::Controller::Catalog';

sub index {
    my $self = shift;
}

sub add_to_cart {
    my $self = shift;

    my $cart = $self->cart;

    # model
    my $items      = $cart->data('items') || [];
    my $product_id = $self->param('product_id');
    my $quantity   = $self->param('quantity');
    push @$items, { product_id => $product_id, quantity => $quantity };
    $cart->data( items => $items );

    use DDP;
    p $cart->data('items');

    $self->template('product/index');
    # $self->flash( ref => $self->req->url->to_string );
    # $self->redirect_to('cart');
}

1;
