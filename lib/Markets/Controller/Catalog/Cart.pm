package Markets::Controller::Catalog::Cart;
use Mojo::Base 'Markets::Controller::Catalog';

sub index {
    my $self = shift;
    my $items = $self->cart->data('items');
    $self->stash(items => $items);
}

1;
