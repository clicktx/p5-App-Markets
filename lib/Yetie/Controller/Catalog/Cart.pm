package Yetie::Controller::Catalog::Cart;
use Mojo::Base 'Yetie::Controller::Catalog';

sub init_form {
    my ( $self, $form, $cart ) = @_;

    $cart->items->each(
        sub {
            my ( $item, $i ) = @_;
            $form->field("quantity.$i")->value( $item->quantity );
        }
    );

    return $self->SUPER::init_form();
}

sub index {
    my $self = shift;

    my $cart = $self->cart;
    $self->stash( cart => $cart );    # for templates

    # 配送先が1箇所の場合は配送商品をカートに戻す
    $self->service('cart')->revert_shipping_item() if $cart->shipments->size == 1;

    # Initialize form
    my $form = $self->form_set('cart');
    $self->init_form( $form, $cart );

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

sub clear {
    my $self = shift;
    $self->cart->clear;
    return $self->redirect_to('RN_cart');
}

1;
