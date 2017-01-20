package Markets::Service::Customer;
use Mojo::Base 'Markets::Service';

# sub get_history { $_[1]->db_session->data('history') || [] }
sub get_history { shift->controller->db_session->data('history') || [] }

sub add_history {
    my $self = shift;
    my $c    = $self->controller;

    my $history = $self->get_history;

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
    say "   history is";
    p $history;
    $c->app->log->debug('aaa');
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

L<Markets::Service>
