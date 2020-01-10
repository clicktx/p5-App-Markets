package Yetie::Service::Checkout::Complete;
use Mojo::Base -role;

sub complete {
    my $self = shift;
    my $c    = $self->c;

    # Double post
    if ( my $res = $self->_validate_double_post ) { return $res }

    my $checkout = $self->get;

    # XXX:未完成 Address正規化
    # set時(set_billing_address,set_shipping_address)に正規化を行う？

    # shipping address
    $self->_shipping_address($checkout);

    # billing address
    $self->_billing_address($checkout);

    # Make order data
    my $order_data = $self->_get_order_data($checkout);

    # Store order
    my $res = $self->resultset('Sales')->create_order($order_data);

    # Delete cart-items and token
    $self->destroy;

    # Store error
    if ( !$res ) {
        return $c->reply->error(
            title         => 'checkout.complete.err.title',
            error_message => 'checkout.complete.err.message',
        );
    }

    # Completed
    $c->flash( sales_id => $res->id );
    return $c->prg_to('rn.checkout.complete');
}

sub _billing_address {
    my ( $self, $checkout ) = @_;

    my $billing_address_id = $self->service('address')->set_address_id( $checkout->billing_address );

    # Add to customer address
    # NOTE: 選択無しでアドレス帳に登録するのは良いUXか考慮
    $self->service('customer')->add_to_address_book($billing_address_id);

    return;
}

sub _get_order_data {
    my ( $self, $checkout ) = @_;

    my $order_data = $checkout->to_order_data;

    # オーダーデータ整形
    # ログイン購入
    my $customer_id = $self->c->server_session->customer_id;
    if ($customer_id) {
        $order_data->{customer} = { id => $customer_id };
    }
    else {
        # ゲスト購入
        # emailからcustomer_idを算出？新規顧客の場合はcustomer作成
        $order_data->{customer} = {};
    }

    # XXX: WIP ゲスト購入
    delete $order_data->{email};

    # Add token
    $order_data->{token} = $self->c->token->get;

    return $order_data;
}

sub _shipping_address {
    my ( $self, $checkout ) = @_;

    $checkout->sales_orders->each(
        sub {
            my $sales_order         = shift;
            my $shipping_address_id = $self->service('address')->set_address_id( $sales_order->shipping_address );

            # Add to customer address
            # NOTE: 選択無しでアドレス帳に登録するのは良いUXか考慮
            $self->service('customer')->add_to_address_book($shipping_address_id);
        }
    );
    return;
}

sub _validate_double_post {
    my $self = shift;
    my $c    = $self->c;

    my $token = $c->param('token');
    return if $c->token->validate($token);

    my $sales = $c->resultset('Sales')->find( { token => $token } );
    return $c->reply->error(
        title         => 'checkout.double.post.err.title',
        error_message => 'checkout.double.post.err.message',
    ) if !$sales;

    # Ordered
    $c->flash( sales_id => $sales->id );
    return $c->prg_to('rn.checkout.complete');
}

1;

__END__

=head1 NAME

Yetie::Service::Checkout::Complete

=head1 SYNOPSIS

    use Role::Tiny::With;

    with 'Yetie::Service::Checkout::Complete';

    ...

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Service::Checkout::Complete> inherits all attributes from L<Mojo::Base> and implements
the following new ones.

=head1 METHODS

L<Yetie::Service::Checkout::Complete> inherits all methods from L<Mojo::Base> and implements
the following new ones.

=head2 C<complete>

    $service->complete;

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Service>
