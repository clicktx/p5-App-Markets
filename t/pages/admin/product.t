package t::pages::admin::product;

use Mojo::Base 't::pages::common';
use t::Util;
use Test::More;
use Test::Mojo;

sub t01_request : Tests() {
    my $self = shift;
    my $t    = $self->t;

    # Login
    $self->admin_loged_in;

    $t->get_ok('/admin/product/create')->status_is(200);
    $t->get_ok('/admin/product/1/duplicate')->status_is(200);
    $t->get_ok('/admin/product/1/edit')->status_is(200);
    $t->get_ok('/admin/product/1/edit/category')->status_is(200);
    $t->get_ok('/admin/product/1/delete')->status_is(200);
}

__PACKAGE__->runtests;
