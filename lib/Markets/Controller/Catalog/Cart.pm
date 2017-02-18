package Markets::Controller::Catalog::Cart;
use Mojo::Base 'Markets::Controller::Catalog';

sub index {
    my $self = shift;
    my $items = $self->cart->items;

    # 複数配送先を無関係に
    $items = $items->flatten;

    $self->stash( items => $items );
}

1;
