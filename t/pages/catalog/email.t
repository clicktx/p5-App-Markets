package t::pages::catalog::email;

use Mojo::Base 't::common';
use t::Util;
use Test::More;
use Test::Mojo;

sub startup : Test(startup) {
    my $self = shift;
    $self->SUPER::startup;
    $self->t->ua->max_redirects(0);
}

sub t01_sent : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $t->get_ok('/email/sent-magic-link')->status_is(200);
    $t->post_ok('/email/sent-magic-link')->status_is(404);
}

__PACKAGE__->runtests;
