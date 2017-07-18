package Markets::Controller::Catalog::Cart;
use Mojo::Base 'Markets::Controller::Catalog';

sub index {
    my $self = shift;

    my $cart = $self->service('cart')->create_entity;
    $self->stash( cart => $cart );

    $self->render();
}

1;
