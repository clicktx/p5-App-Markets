package Yetie::Controller::Catalog::Account;
use Mojo::Base 'Yetie::Controller::Catalog';

sub authorize {
    my $c = shift;
    return 1 if $c->is_logged_in;

    $c->flash( ref => $c->current_route );
    $c->redirect_to( $c->url_for('RN_customer_login') );
    return 0;
}

sub logout {
    my $c = shift;

    my $session = $c->server_session;
    $session->remove_session;
    $c->remove_cookie('remember_me');

    return $c->render();
}

sub home {
    my $c = shift;
    $c->render();
}

sub orders {
    my $c = shift;
    $c->render();
}

sub wishlist {
    my $c = shift;
    $c->render();
}

1;
