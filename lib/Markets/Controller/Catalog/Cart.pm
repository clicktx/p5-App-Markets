package Markets::Controller::Catalog::Cart;
use Mojo::Base 'Markets::Controller::Catalog';

sub index {
    my $self = shift;

    my $cart = $self->service('cart')->create_entity;
    $self->stash( cart => $cart );

    my $form = $self->form_set('cart');
    $cart->items->each(
        sub {
            my ( $item, $i ) = @_;
            $form->field("item.$i.quantity")->value( $item->quantity );
        }
    );

    return $self->render() unless $form->has_data;

    if   ( $form->validate ) { }
    else                     { }

    $self->render();
}

1;
