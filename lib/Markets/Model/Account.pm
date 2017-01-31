package Markets::Model::Account;
use Mojo::Base 'Markets::Model';

sub remove_session {
    my ( $self, $session ) = @_;

    # 2重ログアウトの対策
    $session->_is_flushed(1);
    return 0 unless $session->_is_stored;

    say "logout ... remove session";    #debug
    $session->expire;
    $session->_is_flushed(0);
    return 1;
}

1;
__END__

=head1 NAME

Markets::Model::Account

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=head2 remove_session

    my $session = $c->server_session;
    my $bool = $c->model('account')->remove_session($session);

return C<boolean> value.

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

L<Markets::Model> L<Mojolicious::Plugin::Model> L<MojoX::Model>
