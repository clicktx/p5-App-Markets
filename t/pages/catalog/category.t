package t::pages::catalog::category;

use Mojo::Base 't::pages::common';
use t::Util;
use Test::More;
use Test::Mojo;

sub t01_basic : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $t->get_ok('/category/1')->status_is(200)->content_like(qr/Sports/i);
    $t->get_ok('/category/999')->status_is(404);
}

__PACKAGE__->runtests;
