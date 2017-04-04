package Markets::Service::Customer;
use Mojo::Base 'Markets::Service';
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

    # Merge cart data
    my $stored_cart = $c->factory(
        'entity-cart',
        {
            cart_id   => $customer_id,
            cart_data => $session->store->load_cart_data($customer_id),
        }
    )->create;

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
    catch { $c->model('common')->dbic_txn_failed($_) };
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

=head2 C<add_history>

    # $app->config('history_disable_route_names') is unsave list.
    $c->service('customer')->add_history;

    Add history current URL for server session.
    Unsave list setting in L<Markets::Routes>.

=head2 C<load_history>

    my $history = $c->service('customer')->load_history;

=head2 C<login>

    $c->service('customer')->login($customer_id);

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

L<Markets::Service>
