package Yetie::Controller::Catalog::Account;
use Mojo::Base 'Yetie::Controller::Catalog';

sub authorize {
    my $c = shift;
    return 1 if $c->is_logged_in;

    # NOTE: 最終リクエストがPOSTの場合はhistoryから最後のGETリクエストを取得する？
    #       sessionが切れている（はず）なのでhistoryから取得は難しいか？
    #       cookie_session のlanding_pageで良い？
    #       catalog/staff 両方で必要
    $c->flash( ref => $c->req->url->to_string ) if $c->is_get_request;

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

    # Remove server session
    my $session = $c->server_session;
    $session->cart_session->remove;
    $session->remove_session;

    # Remove auto login cookie & token
    $c->service('customer')->remove_remember_me_token;

    # Remove cookie session
    $c->cookie_session( expires => 1 );

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
