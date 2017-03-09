package Markets::Service::Customer;
use Mojo::Base 'Markets::Service';

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

    my $session = $self->controller->server_session;

    # Merge cart data
    my $cart_data        = $session->cart_data;
    my $stored_cart_data = $session->cart_data($customer_id);
    my $merged_cart_data = $self->model('cart')->merge_cart( $cart_data, $stored_cart_data );

    # Set cart data
    $session->cart_session->data($merged_cart_data);

    # Set customer id
    $session->customer_id($customer_id);

    {
        my $txn = $self->app->schema->txn_scope_guard;

        # Change cart_id
        $session->remove_cart($customer_id);
        $session->cart_id($customer_id);

        # Regenerate sid
        my $sid = $session->regenerate_sid;
        say "  .. regenerate_sid: " . $sid;    #debug

        $txn->commit;
        return $sid;
    }
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

=head2 C<logout>

    $c->service('customer')->logout;

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

L<Markets::Service>
