package Markets::Service::Customer;
use Mojo::Base 'Markets::Service';

sub get_history { shift->controller->db_session->data('history') || [] }

# getアクセスのみ履歴として保存する
sub add_history {
    my $self = shift;
    my $c    = $self->controller;

    my $history = $self->get_history;
    my $url     = $c->req->url->to_string;

    # リロードじゃないか
    # query付きgetの扱いをどうするか？　-> 別pageとして扱う
    return if @$history and $history->[0] eq $url;

    # 再訪問の場合は最新の履歴とする
    @$history = grep { $_ ne $url } @$history;

    # 保存する最大履歴数
    # my $max = $self->app->const('CUSTOMER_HISTORY_MAX');

    unshift @$history, $url;
    use DDP;
    say "   history is";    # debug
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

L<Markets::Service>
