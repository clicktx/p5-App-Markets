package Markets::Controller::Catalog::Cart;
use Mojo::Base 'Markets::Controller::Catalog';

sub index {
    my $self = shift;

    my $cart = $self->service('cart');
    my $items = $cart->items;

    # 複数配送先を無関係に
    $items = $items->flatten;

    $self->stash( items => $items );
}

1;
