package Markets::Controller::Catalog::Product;
use Mojo::Base 'Markets::Controller::Catalog';

sub index {
    my $self = shift;
}

sub add_to_cart {
    my $self = shift;
    my $cart = $self->cart;

    # modelで
    my $product_id = $self->param('product_id');
    my $quantity   = $self->param('quantity');
    my $item       = { product_id => $product_id, quantity => $quantity };
    say "add_to_cart: errrrrrrrorroror!!!!!!!!!!!!!!!!" unless $cart->add_item($item);

    use DDP;
    p $cart->data('items');

    $self->flash( ref => $self->req->url->to_string );
    $self->redirect_to('RN_cart');
}

1;
