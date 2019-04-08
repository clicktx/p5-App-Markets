package t::pages::catalog::account;

use Mojo::Base 't::common';
use t::Util;
use Test::More;
use Test::Mojo;

our @paths;

sub startup : Test(startup) {
    my $self = shift;
    $self->SUPER::startup;

    $self->t->ua->max_redirects(0);
}

sub t01_required_authentication : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $t->get_ok($_)->status_is( 302, 'right redirect' )->header_is( Location => '/login' ) for @paths;
}

sub t02_required_authentication_after_login : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $self->customer_logged_in;
    $t->get_ok($_)->status_is( 200, 'right redirect' ) for @paths;
}

__PACKAGE__->runtests;
