package Yetie::Service::Customer;
use Mojo::Base 'Yetie::Service';
use Try::Tiny;

# getアクセスのみ履歴として保存する
sub add_history {
    my $self = shift;
    my $c    = $self->controller;

    # 履歴を残さないルート
    my $route_name          = $c->current_route;
    my $disable_route_names = $self->app->config('history_disable_route_names');
    return if grep { $_ eq $route_name } @$disable_route_names;

    my $history = $self->load_history;
    my $url     = $c->req->url->to_string;

    # リロードじゃないか
    # query付きgetの扱いをどうするか？　-> 別pageとして扱う
    return if @$history and $history->[0] eq $url;

    # 再訪問の場合は最新の履歴とする
    @$history = grep { $_ ne $url } @$history;

    # 保存する最大履歴数
    # my $max = $self->app->pref('CUSTOMER_HISTORY_MAX');

    unshift @$history, $url;
    use DDP;
    say "   history is";    # NOTE: debug
    p $history;
    $c->server_session->data( history => $history );
}

sub create_new_customer {
    my ( $self, $email ) = @_;
    return $self->resultset('Customer')->create_new_customer($email);
}

sub find_customer {
    my ( $self, $email ) = @_;

    my $result = $self->resultset('Customer')->find_by_email($email);
    my $data = $result ? $result->to_data : {};

    return $self->factory('entity-customer')->construct($data);
}

sub get_addresses {
    my ( $self, $customer_id, $type_name ) = @_;

    my $address_types   = $self->service('address')->get_address_types;
    my $address_type_id = $address_types->get_id_by_name($type_name);

    my $rs = $self->resultset('Address')->search(
        {
            'customer_addresses.customer_id'     => $customer_id,
            'customer_addresses.address_type_id' => $address_type_id,
        },
        { prefetch => 'customer_addresses' }
    );
    return $self->factory('list-addresses')->construct( list => $rs->to_data );
}

sub get_billing_addresses { shift->get_addresses( shift, 'billing_address' ) }

sub get_shipping_addresses { shift->get_addresses( shift, 'shipping_address' ) }

sub load_history {
    my $self = shift;
    my $c    = $self->controller;
    $c->server_session->data('history') || [ $c->cookie_session('landing_page') ];
}

sub logged_in {
    my ( $self, $customer_id ) = @_;
    my $session = $self->controller->server_session;

    # Double login
    return 1 if $session->customer_id;

    # Set customer id (logedin flag)
    $session->customer_id($customer_id);

    # Merge cart
    my $merged_cart = $self->service('cart')->merge_cart($customer_id);

    # Regenerate sid and set cart id
    $session->create( { cart_id => $customer_id } );
    $session->cart->data( $merged_cart->to_data );

    # NOTE: ログインログに記録する方が良い？
    # Update last login date
    $self->resultset('Customer')->last_loged_in_now($customer_id);

    return 1;
}

sub login_process {
    my ( $self, $email, $raw_password ) = @_;

    # Find account
    my $customer = $self->find_customer($email);
    return $self->_login_failed( 'login.failed.not_found', email => $email )
      unless $customer->is_registered;

    # Authentication
    return $self->_login_failed( 'login.failed.password', email => $email )
      unless $customer->password->is_verify($raw_password);

    return $self->logged_in( $customer->id );
}

sub store_address {
    my ( $self, $address_type, $address_id ) = @_;
    my $c = $self->controller;

    my $customer_id     = $c->server_session->customer_id;
    my $address_type_id = $c->service('address')->get_address_types->get_id_by_name($address_type);
    return if !$customer_id or !$address_type_id or !$address_id;

    my $result = $c->resultset('Customer::Address')->find_or_new(
        {
            customer_id     => $customer_id,
            address_type_id => $address_type_id,
            address_id      => $address_id,
        }
    );
    return if $result->in_storage;

    $result->insert;
}

sub store_billing_address { shift->store_address( 'billing_address', shift ) }

sub store_shipping_address { shift->store_address( 'shipping_address', shift ) }

# NOTE: logging 未完成
sub _login_failed {
    my $self = shift;
    $self->controller->stash( status => 401 );

    # Logging
    $self->logging_warn(@_);
    return 0;
}

1;
__END__

=head1 NAME

Yetie::Service::Customer

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Service::Customer> inherits all attributes from L<Yetie::Service> and implements
the following new ones.

=head1 METHODS

L<Yetie::Service::Customer> inherits all methods from L<Yetie::Service> and implements
the following new ones.

=head2 C<add_history>

    # $app->config('history_disable_route_names') is unsave list.
    $c->service('customer')->add_history;

    Add history current URL for server session.
    Unsave list setting in L<Yetie::Routes>.

=head2 C<create_new_customer>

    Create new customer.

    my $customer_id = $service->create_new_customer($email);

Return customer ID(integer)

=head2 C<find_customer>

    my $entity = $service->find_customer($email);

Return L<Yetie::Domain::Entity::Customer> object.

=head2 C<get_addresses>

    my $addresses = $service->get_addresses( $customer_id, $address_type_name );

Return L<Yetie::Domain::List::Addresses> object.

=head2 C<get_billing_addresses>

    my $addresses = $service->get_billing_addresses($customer_id);

    # Alias method
    my $addresses = $service->get_addresses( $customer_id, 'billing_address' );

Return L<Yetie::Domain::List::Addresses> object.
See L</get_addresses>

=head2 C<get_shipping_addresses>

    my $addresses = $service->get_shipping_addresses($customer_id);

    # Alias method
    my $addresses = $service->get_addresses( $customer_id, 'shipping_address' );

Return L<Yetie::Domain::List::Addresses> object.
See L</get_addresses>

=head2 C<load_history>

    my $history = $c->service('customer')->load_history;

=head2 C<logged_in>

Set customer logged-in flag to server_session.

    my $bool = $service->logged_in($customer_id);

Return boolean value.

=head2 C<login_process>

    my $bool = $service->story->login_process;

Returns true if log-in succeeded.

=head2 C<store_address>

    $service->store_address('billing_address');
    $service->store_address('shipping_address');

Store customer address in storage from cart data.

If it is not registered, not logged in, or there is no cart address id, false is returned.

=head2 C<store_billing_address>

    $service->store_billing_address;

See L</store_address>

=head2 C<store_shipping_address>

    $service->store_shipping_address;

See L</store_address>

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Service>
