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
    my $customer_id = $self->server_session->data('customer_id');
    my $order = { customer_id => $customer_id, };

    # Store order and items to DB
    my $cb = sub {

        # Order
        $order->{order_no} = $schema->sequence('Order');
        $schema->resultset('Order')->create($order);

        # Items
        # $schema->resultset('Order')->create($order); # itemsがbulk insert されない

# DBIx::Class::ResultSet https://metacpan.org/pod/DBIx::Class::ResultSet#populate
# chekout の他に注文修正等で使う可能性があるのでresultsetにmethod化しておく？
# $schema->resultset('Order')->create_with_bulkinsert_items($order);

        # bulk insert
        my $order_id = $schema->storage->last_insert_id;
        my $data = $self->model('item')->to_array( $order_id, $items );
        $schema->resultset('Order::Item')->populate($data);
    };

    use Try::Tiny;
    try {
        $schema->txn_do($cb);
    }
    catch {
        $self->model('common')->dbic_txn_failed($_);
    };

    # cart sessionクリア
    $cart->clear;

    # redirect_to thank you page
}

1;
