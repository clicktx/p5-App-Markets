package t::pages::signup;

use Mojo::Base 't::pages::common';
use t::Util;
use Test::More;
use Test::Mojo;

sub startup : Test(startup) {
    my $self = shift;
    $self->SUPER::startup;
    $self->t->ua->max_redirects(0);
}

sub t01_register_form : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $t->get_ok('/signup')->status_is( 200, 'right registration form page' );

    my $post_data = { csrf_token => $self->csrf_token };
    $t->post_ok( '/signup', form => $post_data )->status_is( 200, 'right form validate error' );

    $post_data = {
        csrf_token     => $self->csrf_token,
        email          => 'test@example.com',
        password       => '12345678',
        password_again => '12345678',
    };
    $t->post_ok( '/signup', form => $post_data )->status_is( 302, 'right form validated' );
}

__PACKAGE__->runtests;
