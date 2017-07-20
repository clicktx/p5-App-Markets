package Markets::Controller::Catalog::Cart;
use Mojo::Base 'Markets::Controller::Catalog';

sub index {
    my $self = shift;

    my $cart = $self->cart;
    $self->stash( cart => $cart );

    my $form = $self->form_set('cart');
    $cart->items->each(
        sub {
            my ( $item, $i ) = @_;
            $form->field("quantity.$i")->value( $item->quantity );
        }
    );

    return $self->render() unless $form->has_data;

    if ( $form->validate ) {

        # Edit cart
        $cart->items->each(
            sub {
                my ( $item, $i ) = @_;
                $item->quantity( $form->scope_param('quantity')->[$i] );
            }
        );
    }
    $self->render();
}

1;
