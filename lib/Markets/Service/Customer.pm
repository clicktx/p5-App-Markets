package Markets::Service::Customer;
use Mojo::Base 'Markets::Service';
use Carp qw/croak/;
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
    say "   history is";    # debug
    p $history;
    $c->server_session->data( history => $history );
}

# SELECT me.id, me.password_id, me.created_at, me.updated_at, password.id, password.hash, password.created_at, password.updated_at, emails.id, emails.customer_id, emails.email_id, emails.is_primary, email.id, email.address, email.is_verified FROM customers me  JOIN passwords password ON password.id = me.password_id LEFT JOIN customer_emails emails ON emails.customer_id = me.id LEFT JOIN emails email ON email.id = emails.email_id WHERE ( email.address = ? ) ORDER BY me.id: 'c@x.org'
# 単一のentityを生成
sub create_entity {
    my $self = shift;
    my $args = @_ > 1 ? +{@_} : shift;

    # NOTE: whereが空になるのを避けること
    croak "requied parameter 'customer_id' or 'email'" if !$args->{customer_id} and !$args->{email};

    my $where;
    $where = { 'me.id'         => $args->{customer_id} } if $args->{customer_id};
    $where = { 'email.address' => $args->{email} }       if $args->{email};

    my $data = $self->app->schema->resultset('Customer')
      ->search( $where, { prefetch => [ 'password', { emails => 'email' } ] }, )->hashref_first;

    $self->app->factory('entity-customer')->create( $data || {} );
}

sub load_history {
    my $self = shift;
    my $c    = $self->controller;
    $c->server_session->data('history') || [ $c->cookie_session('landing_page') ];
}

sub login {
    my ( $self, $customer_id ) = @_;
    return unless $customer_id;

    my $c       = $self->controller;
    my $session = $c->server_session;

    # Merge cart data
    my $cart_data = $session->store->load_cart_data($customer_id);
    $cart_data->{cart_id} = $customer_id;
    my $stored_cart = $c->factory('entity-cart')->create($cart_data);

    my $merged_cart = $c->cart->merge($stored_cart);
    $c->cart($merged_cart);

    # Set customer id
    $session->customer_id($customer_id);

    try {
        my $txn = $self->app->schema->txn_scope_guard;

        # Change cart_id
        $session->remove_cart($customer_id);
        $session->cart_id($customer_id);

        # Regenerate sid
        $session->regenerate_sid;

        $txn->commit;
    }
    catch { $c->app->schema->txn_failed($_) };
}

1;
__END__

=head1 NAME

Markets::Model::Service::Customer - Application Service Layer

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Service::Customer> inherits all attributes from L<Markets::Service> and implements
the following new ones.

=head1 METHODS

L<Markets::Service::Customer> inherits all methods from L<Markets::Service> and implements
the following new ones.

=head2 C<add_history>

    # $app->config('history_disable_route_names') is unsave list.
    $c->service('customer')->add_history;

    Add history current URL for server session.
    Unsave list setting in L<Markets::Routes>.

=head2 C<create_entity>

    my $customer = $c->service('customre')->create_entity($customer_id);

    my $customer = $c->service('customre')->create_entity($customer_email);

=head2 C<load_history>

    my $history = $c->service('customer')->load_history;

=head2 C<login>

    $c->service('customer')->login($customer_id);

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

L<Markets::Service>
