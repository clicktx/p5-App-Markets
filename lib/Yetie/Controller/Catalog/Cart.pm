package Yetie::Controller::Catalog::Cart;
use Mojo::Base 'Yetie::Controller::Catalog';

sub init_form {
    my ( $c, $form, $cart ) = @_;

    $cart->items->each(
        sub {
            my ( $item, $num ) = @_;
            my $i = $num - 1;
            $form->field("quantity.$i")->value( $item->quantity );
        }
    );

    return $c->SUPER::init_form();
}

sub index {
    my $c    = shift;
    my $cart = $c->cart;

    # Revert cart
    $cart->revert;

    # Initialize form
    my $form = $c->form('cart');
    $c->init_form( $form, $cart );

    # Get request
    return $c->render() if $c->is_get_request;

    # Validation form
    return $c->render() if !$form->do_validate;

    # Edit cart
    $cart->items->each(
        sub {
            my ( $item, $num ) = @_;
            my $i = $num - 1;
            $item->quantity( $form->scope_param('quantity')->[$i] );
        }
    );
    $c->render();
}

sub clear {
    my $c = shift;
    $c->cart->clear_items;
    return $c->redirect_to('rn.cart');
}

sub delete {
    my $c = shift;

    my $form = $c->form('cart-delete');
    return $c->reply->exception('Bad request') if !$form->do_validate;

    # NOTE: 複数配送時の場合はitemsのitemを削除する必要がありそう（未実装）
    my $target = $form->param('target_item_id');
    $c->cart->remove_item($target);

    return $c->redirect_to('rn.cart');
}

1;
