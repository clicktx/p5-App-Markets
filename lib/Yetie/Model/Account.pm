package Yetie::Model::Account;
use Mojo::Base 'Yetie::Model';

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

Yetie::Model::Account

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=head2 C<remove_session>

    my $session = $app->server_session;
    my $bool = $app->model('account')->remove_session($session);

return C<boolean> value.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Model> L<Mojolicious::Plugin::Model> L<MojoX::Model>
