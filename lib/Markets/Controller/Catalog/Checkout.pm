package Markets::Controller::Catalog::Checkout;
use Mojo::Base 'Markets::Controller::Catalog';

sub index {
    my $self = shift;
    $self->render();
}

sub shipping {
    my $self = shift;
    $self->render();
}

sub complete {
    my $self = shift;

    # TODO: model化する
    # itemsが無い場合は実行しない
    my $cart = $self->cart;

# NOTE: 本番環境ではitemsに商品がある場合はcomplete出来ない。shipmentsに商品を全て移すべき。
    $self->redirect_to('RN_cart') if !$cart->items->size;

    # cartデータからorderデータ作成
    my $order = { billing_address => 'ogikubo' };
    my $customer_id = $self->server_session->data('customer_id');
    $order->{customer_id} = $customer_id;

    # items
    # NOTE: 実際にはshipmentsは作成されているはず
    my $shipments = [ { shipping_address => 'kamiizumi' } ];
    my $cart_data = $cart->to_hash;
    $shipments->[0]->{items} = $cart_data->{items};
    $order->{shipments} = $shipments;

    # Store order
    my $schema = $self->app->schema;
    my $cb     = sub {

        # Order
        $order->{order_no} = $schema->sequence('Order');
        $schema->resultset('Order')->create($order);

        # Items
        # $schema->resultset('Order')->create($order); # itemsがbulk insert されない

# NOTE:
# DBIx::Class::ResultSet https://metacpan.org/pod/DBIx::Class::ResultSet#populate
# chekout の他に注文修正等で使う可能性があるのでresultsetにmethod化しておく？
# $schema->resultset('Order')->create_with_bulkinsert_items($order);

        # bulk insert
        # my $items = $cart->items->first->to_array;
        # my $order_id = $schema->storage->last_insert_id;
        # my $data = $self->model('item')->to_array( $order_id, $items );
        # $schema->resultset('Order::Item')->populate($data);
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
    $self->render();
}

1;
