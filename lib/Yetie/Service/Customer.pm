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
    say "   history is";    # debug
    p $history;
    $c->server_session->data( history => $history );
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

    # 2重ログイン
    return if $session->customer_id;

    # Set customer id (logedin flag)
    $session->customer_id($customer_id);

    # Before data
    my $session_data    = $session->data;
    my $visitor_cart_id = $session->cart_id;

    # Merge cart data
    my $cart_data   = $session->store->load_cart_data($customer_id) || {};
    my $stored_cart = $c->factory('entity-cart')->create($cart_data);
    my $merged_cart = $c->cart->merge($stored_cart);

    try {
        my $txn = $self->schema->txn_scope_guard;

        # Remove before cart(and session) from DB
        $session->remove_cart($visitor_cart_id);

        # Regenerate sid and set cart id
        $session->create( { cart_id => $customer_id } );
        $session->data($session_data);
        $session->cart->data( $merged_cart->to_data );
        $session->flush;

        $txn->commit;
    }
    catch { $c->schema->txn_failed($_) };
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

=head2 C<load_history>

    my $history = $c->service('customer')->load_history;

=head2 C<login>

    $c->service('customer')->login($customer_id);

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Service>
