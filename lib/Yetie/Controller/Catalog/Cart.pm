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
    my $c = shift;

    my $cart = $c->cart;
    $c->stash( cart => $cart );    # for templates

    # 配送先が1箇所の場合は配送商品をカートに戻す
    $c->service('cart')->revert_shipping_item() if $cart->shipments->size == 1;

    # Initialize form
    my $form = $c->form('cart');
    $c->init_form( $form, $cart );

    return $c->render() unless $form->has_data;

    if ( $form->do_validate ) {

        # Edit cart
        $cart->items->each(
            sub {
                my ( $item, $num ) = @_;
                my $i = $num - 1;
                $item->quantity( $form->scope_param('quantity')->[$i] );
            }
        );
    }
    $c->render();
}

sub clear {
    my $c = shift;
    $c->cart->clear_items;
    return $c->redirect_to('RN_cart');
}

sub delete {
    my $c = shift;

    my $form = $c->form('cart-delete');
    return $c->reply->exception('Bad request') unless $form->do_validate;

    # NOTE: 複数配送時の場合はitemsのitemを削除する必要がありそう（未実装）
    my $target = $form->param('target_item_id');
    $c->cart->remove_item($target);

    return $c->redirect_to('RN_cart');
}

1;
