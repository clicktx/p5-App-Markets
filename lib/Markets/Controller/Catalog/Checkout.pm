package Markets::Controller::Catalog::Checkout;
use Mojo::Base 'Markets::Controller::Catalog';

sub index {
    my $self = shift;
}

sub complete {
    my $self = shift;

    # bad!
    my $cart   = $self->service('cart');
    my $schema = $self->app->schema;

    # 購入商品データ作成
    my $items = $cart->items->first->to_array;
    use DDP;
    p $cart->data('items');
    p $items;

    # itemsが無い場合は実行しない
    $self->redirect_to('RN_cart') if !@{$items};

    # order作成
    # itemsへ保存(relationで自動保存？)
    my $cb;
    $cb = sub {
        $schema->resultset('Order')->create(
            {
                items => $items
            }
        );
    };

    use Try::Tiny;
    my $res;
    try {
        $res = $cb->();
    }
    catch {
        if ( $_ =~ /Rollback failed/ ) {

            # ロールバックに失敗した場合
        }

        # 何らかのエラーによりロールバックした
        warn $@;
    };

    # cart sessionクリア
    $cart->clear;

    # redirect_to thank you page
}

1;
