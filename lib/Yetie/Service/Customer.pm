package Yetie::Service::Customer;
use Mojo::Base 'Yetie::Service';
use Try::Tiny;

has resultset => sub { shift->app->schema->resultset('Customer') };

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

sub find_customer {
    my ( $self, $email ) = @_;

    my $result = $self->resultset->find_by_email($email);
    my $data = $result ? $result->to_data : {};

    return $self->factory('entity-customer')->create($data);
}

sub load_history {
    my $self = shift;
    my $c    = $self->controller;
    $c->server_session->data('history') || [ $c->cookie_session('landing_page') ];
}

sub login_process {
    my ( $self, $email, $password ) = @_;

    # Find account
    my $customer = $self->find_customer($email);
    return $self->_login_failed( 'login.failed.not_found', email => $email )
      unless $customer->is_registerd;

    # Authentication
    return $self->_login_failed( 'login.failed.password', email => $email )
      unless $customer->verify_password($password);

    return $self->_logged_in( $customer->id );
}

sub _logged_in {
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
    return 1;
}

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

=head2 C<find_customer>

    my $entity = $service->find_customer($email);

Return L<Yetie::Domain::Entity::Customer> object.

=head2 C<load_history>

    my $history = $c->service('customer')->load_history;

=head2 C<login_process>

    my $bool = $service->story->login_process;

Returns true if login succeeded.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Service>
