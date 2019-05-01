package t::pages::catalog::auth::signup;

use Mojo::Base 't::common';
use t::Util;
use Test::More;
use Test::Mojo;

my $register_email = 'new_customer_on_page@example.com';

sub startup : Test(startup) {
    my $self = shift;
    $self->SUPER::startup;
    $self->t->ua->max_redirects(0);
}

sub t01_register_form : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $t->get_ok('/signup')->status_is( 200, 'right registration form page' );
    $t->get_ok('/signup/done')->status_is( 200, 'right complete page' );

    my $post_data = { csrf_token => $self->csrf_token };
    $t->post_ok( '/signup', form => $post_data )->status_is( 200, 'right form validate error' );

    $post_data = {
        csrf_token => $self->csrf_token,
        email      => $register_email,
    };
    $t->post_ok( '/signup', form => $post_data )->status_is( 302, 'right form validated' );
}

sub t02_callback : Tests() {
    my $self = shift;
    my $t    = $self->t;

    # token
    my $token = $t->app->resultset('AuthenticationRequest')->find_last_by_email($register_email)->token;
    $t->get_ok( '/get-started/' . $token )->status_is(302);

    my $customer_id = $self->app->resultset('Customer')->last_id;
    my $customer    = $self->app->service('customer')->find_customer($register_email);
    is $customer->id, $customer_id, 'right register';
    is $self->server_session->customer_id, $customer_id, 'right logged-in';
    ok $customer->emails->primary->is_verified, 'right email verified';

    # re-request
    $t->get_ok( '/get-started/' . $token )->status_is( 400, 'right re-request' );

    # illegal token
    $t->get_ok('/get-started/bad-token')->status_is( 400, 'illegal token' );

    # re-singup
    my $post_data = {
        csrf_token => $self->csrf_token,
        email      => $register_email,
    };
    $t->post_ok( '/signup', form => $post_data );
    $token = $t->app->resultset('AuthenticationRequest')->find_last_by_email($register_email)->token;
    $t->get_ok( '/get-started/' . $token )->status_is( 400, 'right re-signup' );
}

__PACKAGE__->runtests;
