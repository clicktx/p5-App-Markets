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

    my $result = $self->resultset('Customer')->create_new_customer($email);
    return unless $result;

    return $self->factory('entity-customer')->construct( $result->to_data );
}

sub find_customer {
    my ( $self, $email ) = @_;

    my $result = $self->resultset('Customer')->find_by_email($email);
    my $data = $result ? $result->to_data : {};

    return $self->factory('entity-customer')->construct($data);
}

sub get_addresses {
    my ( $self, $customer_id ) = @_;

    my $rs = $self->resultset('Address')->search(
        {
            'customer_addresses.customer_id' => $customer_id,
        },
        { prefetch => 'customer_addresses' }
    );
    return $self->factory('list-addresses')->construct( list => $rs->to_data );
}

sub get_billing_addresses { say "Deprecated"; shift->get_addresses(shift) }

sub get_shipping_addresses { say "Deprecated"; shift->get_addresses(shift) }

sub load_history {
    my $self = shift;
    my $c    = $self->controller;
    $c->server_session->data('history') || [ $c->cookie_session('landing_page') ];
}

sub login {
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

    return $self->login( $customer->id );
}

sub search_customers {
    my ( $self, $form ) = @_;

    my $conditions = {
        where    => '',
        order_by => '',
        page_no  => $form->param('page') || 1,
        per_page => $form->param('per_page') || 5,
    };
    my $rs = $self->resultset('Customer')->search_customers($conditions);

    my $data = {
        meta_title    => 'Customers',
        form          => $form,
        breadcrumbs   => [],
        customer_list => $rs->to_data,
        pager         => $rs->pager,
    };
    return $self->factory('entity-page-customers')->construct($data);
}

sub send_authorization_mail {
    my ( $self, $email ) = @_;

    my $c        = $self->controller;
    my $redirect = $c->flash('ref') || 'RN_home';
    my $token    = $c->service('authorization')->generate_token( $email, { redirect => $redirect } );

    my $customer       = $self->find_customer($email);
    my $callback_route = $customer->is_registered ? 'RN_callback_customer_login' : 'RN_callback_customer_signup';
    my $url            = $c->url_for( $callback_route, token => $token );

    # WIP: Send email

    # NOTE: demo and debug
    $c->flash( callback_url => $url->to_abs );

    my $redirect_route =
      $customer->is_registered ? 'RN_customer_login_email_sended' : 'RN_customer_signup_email_sended';
    return $c->redirect_to($redirect_route);
}

sub store_address {
    my ( $self, $address_id ) = @_;
    my $c = $self->controller;

    my $customer_id = $c->server_session->customer_id;
    return if !$customer_id or !$address_id;

    my $result = $c->resultset('Customer::Address')->find_or_new(
        {
            customer_id => $customer_id,
            address_id  => $address_id,
        }
    );
    return if $result->in_storage;

    $result->insert;
}

sub store_billing_address { say "Deprecated"; shift->store_address(shift) }

sub store_shipping_address { say "Deprecated"; shift->store_address(shift) }

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

Return L<Yetie::Domain::Entity::Customer> object or C<undef>.

=head2 C<find_customer>

    my $entity = $service->find_customer($email);

Return L<Yetie::Domain::Entity::Customer> object.

=head2 C<get_addresses>

    my $addresses = $service->get_addresses($customer_id);

Return L<Yetie::Domain::List::Addresses> object.

=head2 C<get_billing_addresses>

Deprecated

    my $addresses = $service->get_billing_addresses($customer_id);

    # Alias method
    my $addresses = $service->get_addresses($customer_id);

Return L<Yetie::Domain::List::Addresses> object.
See L</get_addresses>

=head2 C<get_shipping_addresses>

Deprecated

    my $addresses = $service->get_shipping_addresses($customer_id);

    # Alias method
    my $addresses = $service->get_addresses($customer_id);

Return L<Yetie::Domain::List::Addresses> object.
See L</get_addresses>

=head2 C<load_history>

    my $history = $c->service('customer')->load_history;

=head2 C<login>

Set customer logged-in flag to server_session.

    my $bool = $service->login($customer_id);

Return boolean value.

=head2 C<login_process>

    my $bool = $service->story->login_process;

Returns true if log-in succeeded.

=head2 C<search_customers>

    my $customers = $service->search_customers($form_object);

Return L<Yetie::Domain::Entity::Page::Customers> Object.

=head2 C<send_authorization_mail>

    $service->send_authorization_mail($email);

Will send an magic link email for log-in or sign-up.

Retuen C<render_to('RN_customer_login_email_sended')> or C<render_to('RN_customer_signup_email_sended')>

=head2 C<store_address>

    $service->store_address($address_id);

Store customer addresses in storage from cart data.

=head2 C<store_billing_address>

Deprecated

    $service->store_billing_address;

See L</store_address>

=head2 C<store_shipping_address>

Deprecated

    $service->store_shipping_address;

See L</store_address>

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Service>
