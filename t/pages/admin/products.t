package t::pages::admin::products;

use Mojo::Base 't::common';
use t::Util;
use Test::More;
use Test::Mojo;

sub t00_login : Tests() { shift->admin_loggin }

sub t01_index : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $t->get_ok('/admin/products')->status_is(200);
}

__PACKAGE__->runtests;
