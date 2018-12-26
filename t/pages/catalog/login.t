package t::pages::catalog::login;

use Mojo::Base 't::pages::common';
use t::Util;
use Test::More;
use Test::Mojo;

my $login_email = 'a@example.org';

sub startup : Test(startup) {
    my $self = shift;
    $self->SUPER::startup;
    $self->t->ua->max_redirects(0);
}

sub t00_login : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $t->get_ok('/login')->status_is( 302, 'right login magic-link' );

    $t->ua->cookie_jar->add(
        Mojo::Cookie::Response->new(
            name  => 'login_with_password',
            value => 1,
        )
    );
    $t->get_ok('/login')->status_is( 302, 'right login with-password' );

    $self->customer_loged_in;
    $t->get_ok('/login')->status_is( 302, 'right after logged-in' );
}

# NOTE: login process is in t/pages/catalog/account.t
sub t01_magic_link_request : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $t->get_ok('/login/magic-link')->status_is( 200, 'right request form' );

    my $post_data = {
        csrf_token => $self->csrf_token,
        email      => $login_email,
    };
    $t->post_ok( '/login/magic-link', form => $post_data )->status_is( 302, 'right token request' );

    # Not registered
    $post_data = {
        csrf_token => $self->csrf_token,
        email      => 'foo-bar-baz@example.org',
    };
    $t->post_ok( '/login/magic-link', form => $post_data )->status_is( 302, 'right not registered' );
}

__PACKAGE__->runtests;
