package Yetie::Controller::Catalog::Account;
use Mojo::Base 'Yetie::Controller::Catalog';

sub authorize {
    my $c = shift;
    return 1 if $c->is_logged_in;

    $c->flash( ref => $c->req->url->to_string );
    $c->redirect_to( $c->url_for('RN_customer_login') );
    return 0;
}

sub remember_me_handler {
    my $c = shift;
    return 1 if $c->is_logged_in;
    return 1 unless $c->is_get_request;
    return 1 unless $c->cookie('has_remember_me');

    $c->flash( return_path => $c->req->url->to_string );
    return $c->redirect_to('RN_customer_login_remember_me');
}

sub logout {
    my $c = shift;

    my $session = $c->server_session;
    $session->remove_session;

    # Remove auto login cookie & token
    $c->service('customer')->remove_remember_me;

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
