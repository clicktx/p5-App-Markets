package t::pages::catalog::account;

use Mojo::Base 't::pages::common';
use t::Util;
use Test::More;
use Test::Mojo;

our @paths;

sub startup : Test(startup) {
    my $self = shift;
    $self->SUPER::startup;

    foreach my $r ( @{ $self->t->app->routes->find('RN_customer_bridge')->children } ) {
        push @paths, $r->render() if $r->is_endpoint;
    }

    $self->t->ua->max_redirects(0);
}

sub t01_required_authrization : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $t->get_ok($_)->status_is( 302, 'right redirect' )->header_is( Location => '/login' ) for @paths;
}

sub t02_required_authrization_after_login : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $self->customer_loged_in;
    $t->get_ok($_)->status_is( 200, 'right redirect' ) for @paths;
}

__PACKAGE__->runtests;
