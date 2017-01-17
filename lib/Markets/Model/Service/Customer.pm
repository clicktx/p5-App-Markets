package Markets::Model::Service::Customer;
use Mojo::Base 'MojoX::Model';

sub get_history { $_[1]->db_session->data('history') || [] }

sub add_history {
    my ( $self, $c ) = @_;
    my $history = $self->get_history($c);

# TODO: "RN_category_name_base" の場合はどうするか？
# プレースホルダを使っているrouteには対応できないためURLを使う方が良い

    my $url = $c->req->url->to_string;

    # リロードじゃないか
    # queryの扱いをどうするか？　-> 別pageとする
    return if @$history and $history->[0] eq $url;

    # 再訪問の場合は最新に
    @$history = grep { $_ ne $url } @$history;

    # 履歴数はmaxではないか
    # my $max = $self->app->const('CUSTOMER_HISTORY_MAX');

    unshift @$history, $url;
    use DDP;
    p $history;
    $c->db_session->data( history => $history );
}

1;
__END__

=head1 NAME

Markets::Model::Service::Customer - Application Service Layer

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

L<Mojolicious::Plugin::Model> L<MojoX::Model>
