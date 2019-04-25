package t::pages::catalog::login;

use Mojo::Base 't::common';
use t::Util;
use Test::More;
use Test::Mojo;

sub startup : Test(startup) {
    my $self = shift;
    $self->SUPER::startup;
    $self->t->ua->max_redirects(0);
}

sub t00_basic : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $t->get_ok('/dropin')->status_is( 200, 'right dropin' )->content_like(qr/drop in/)
      ->element_exists_not('input[name=password]');
}

__PACKAGE__->runtests;
