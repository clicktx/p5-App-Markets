package Yetie::Service::Customer;
use Mojo::Base 'Yetie::Service';
use Carp qw(croak);
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

sub create_customer {
    my ( $self, $email_addr ) = @_;

    my $result = $self->resultset('Customer')->create_customer($email_addr);
    return if !$result;

    return $self->factory('entity-customer')->construct( $result->to_data );
}

sub find_customer {
    my ( $self, $email_addr ) = @_;

    my $result   = $self->resultset('Customer')->find_by_email($email_addr);
    my $data     = $result ? $result->to_data : {};
    my $customer = $self->factory('entity-customer')->construct($data);
    return $customer if $customer->is_member;

    # Guset customer
    my $guest_email = $self->service('email')->find_email($email_addr);
    $customer->emails->append($guest_email);
    return $customer;
}

sub find_or_create_customer {
    my ( $self, $email_addr ) = @_;

    my $customer = $self->find_customer($email_addr);
    return $customer if $customer->is_member;

    return $self->create_customer($email_addr);
}

sub get_address_list {
    my ( $self, $customer_id ) = @_;

    my $rs = $self->resultset('Address')->search(
        {
            'customer_addresses.customer_id' => $customer_id,
        },
        { prefetch => 'customer_addresses' }
    );
    return $self->factory('list-addresses')->construct( list => $rs->to_data );
}

sub get_customer_cart_id {
    my ( $self, $customer_id ) = @_;

    my $res = $self->resultset('Customer')->find($customer_id);
    return if !$res;

    return $res->cart_id;
}

sub load_history {
    my $self = shift;
    my $c    = $self->controller;
    return $c->server_session->data('history') || [ $c->cookie_session('landing_page') ];
}

sub login {
    my ( $self, $customer_id ) = @_;
    croak 'required argument "customer_id"' if !$customer_id;

    # Logged in
    my $session = $self->controller->server_session;
    return $customer_id if $customer_id eq $session->customer_id;

    # Set customer id (logged-in flag)
    $session->customer_id($customer_id);

    # Merge cart
    my $merged_cart = $self->service('cart')->merge_cart($customer_id);

    # Regenerate sid and set cart id
    $session->recreate( { cart_id => $customer_id, cart_data => $merged_cart->to_data } );

    # Update last login time
    $self->resultset('Customer')->last_logged_in_now($customer_id);
    return $customer_id;
}

sub login_process_remember_me {
    my ( $self, $token ) = @_;
    my $authen_service = $self->service('authentication');

    # Verify token
    my $auth = $authen_service->verify($token);
    return $authen_service->remove_remember_token if !$auth->is_verified;

    # Customer
    my $email_addr  = $auth->email->value;
    my $customer_id = $self->find_customer($email_addr)->id;
    return $authen_service->remove_remember_token if !$customer_id;

    # Reset token and Login
    $authen_service->remember_token($email_addr);

    # Activity
    $self->service('activity')->add( login => { customer_id => $customer_id, method => 'remember_me' } );
    return $self->login($customer_id);
}

sub login_process_with_password {
    my ( $self, $form ) = @_;

    # Find account
    my $customer = $self->find_customer( $form->param('email') );
    return $self->_login_failed( 'login.failed.not_found', $form )
      if !$customer->is_member;

    # Authentication
    return $self->_login_failed( 'login.failed.password', $form )
      if !$customer->password->is_verify( $form->param('password') );

    # Activity
    $self->service('activity')->add( login => { customer_id => $customer->id, method => 'with_password' } );
    return $self->login( $customer->id );
}

sub search_customers {
    my ( $self, $form ) = @_;

    my $conditions = {
        where    => q{},
        order_by => q{},
        page_no  => $form->param('page') || '1',
        per_page => $form->param('per_page') || '5',
    };
    my $rs = $self->resultset('Customer')->search_customers($conditions);
    my $customers = $self->factory('list-customers')->construct( list => $rs->to_data );
    return ( $customers, $rs->pager );
}

sub add_to_address_book {
    my ( $self, $address_id ) = @_;
    return if !$address_id;

    my $c           = $self->controller;
    my $customer_id = $c->server_session->customer_id;
    return if !$customer_id;

    my $result = $c->resultset('CustomerAddress')->find_or_new(
        {
            customer_id => $customer_id,
            address_id  => $address_id,
        }
    );
    return if $result->in_storage;

    $result->insert;
    return 1;
}

sub _login_failed {
    my ( $self, $message, $form ) = @_;

    $form->append_error_classes(qw(email password));
    $self->controller->stash( status => 401 );

    # Logging
    # NOTE: WIP: logging 未完成
    $self->logging_warn( $message, email => $form->param('email') );
    return;
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

=head2 C<create_customer>

    Create new customer.

    my $customer_id = $service->create_customer('foo@bar.baz');

Return L<Yetie::Domain::Entity::Customer> object or C<undef>.

=head2 C<find_customer>

    my $entity = $service->find_customer('foo@bar.baz');

Return L<Yetie::Domain::Entity::Customer> object.

=head2 C<find_or_create_customer>

    my $entity = $service->find_or_create_customer('foo@bar.baz');

Return L<Yetie::Domain::Entity::Customer> object.

=head2 C<get_address_list>

    my $addresses = $service->get_address_list($customer_id);

Return L<Yetie::Domain::List::Addresses> object.

=head2 C<get_customer_cart_id>

    my $cart_id = $service->get_customer_cart_id($customer_id);

Return customer cart id.

=head2 C<load_history>

    my $history = $c->service('customer')->load_history;

=head2 C<login>

Set customer logged-in flag to server_session.

    my $customer_id = $service->login($customer_id);

Return customer ID.

=head2 C<login_process_remember_me>

    my $customer_id = $service->login_process_with_password;

Return customer ID if log-in succeeded or C<undefined>.

=head2 C<login_process_with_password>

    my $customer_id = $service->login_process_with_password($form_object);

Return customer ID if log-in succeeded or C<undefined>.

=head2 C<search_customers>

    my ( $customers, $pager ) = $service->search_customers($form_object);

Return L<Yetie::Domain::Entity::Page::Customers> Object.

=head2 C<add_to_address_book>

    $service->add_to_address_book($address_id);

Store customer addresses in storage from cart data.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Service>
