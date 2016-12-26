package Markets::Controller::Catalog::Account;
use Mojo::Base 'Markets::Controller';
use DDP;

sub authorization {
    my $self = shift;
    say "authorization";
    my $session = $self->markets_session;
    my $is_loged_in = $session->data('customer_id') ? 1 : 0;
    $self->redirect_to('customer_login') and return 0 unless $is_loged_in;
    return 1;
}

sub authentication {
    my $self = shift;

    my $session = $self->markets_session;
    my $sid     = $session->regenerate_sid;
    say "  .. regenerate_sid: " . $sid;

    $self->markets_session->data( customer_id => 1 );
    $self->redirect_to('customer_home');
    return 1;
}

sub home {
    my $self = shift;
}

sub login {
    my $self = shift;
    my $session = $self->markets_session;
    p $session->data;
}

sub logout {
    my $self = shift;

    say "logout ... remove session";

    my $session = $self->markets_session;

    # TODO: 後でlogicにする
    # 2重ログアウトの対策
    $session->_is_flushed(1);
    if ( $session->_is_stored ) {
        $session->expire;
        $session->_is_flushed(0);
    }
}

1;
