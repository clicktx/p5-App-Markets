package t::pages::admin::products;

use Mojo::Base 't::pages::common';
use t::Util;
use Test::More;
use Test::Mojo;

sub t01_index : Tests() {
    my $self = shift;
    my $t    = $self->t;

    # Login
    $self->admin_loged_in;

    $t->get_ok('/admin/products')->status_is(200);
}

__PACKAGE__->runtests;
