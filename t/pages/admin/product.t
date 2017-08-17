package t::pages::admin::product;

use Mojo::Base 't::pages::common';
use t::Util;
use Test::More;
use Test::Mojo;

sub t01_create : Tests() {
    my $self = shift;
    my $t    = $self->t;

    # Login
    $self->admin_loged_in;

    $t->get_ok('/admin/product/create')->status_is(200);
}

sub t02_duplicate : Tests() {
    my $self = shift;
    my $t    = $self->t;

    # Login
    $self->admin_loged_in;

    $t->get_ok('/admin/product/create?duplicate_from=1')->status_is(200);
}

sub t03_edit : Tests() {
    my $self = shift;
    my $t    = $self->t;

    # Login
    $self->admin_loged_in;

    $t->get_ok('/admin/product/1/edit')->status_is(200);
}

sub t04_delete : Tests() {
    my $self = shift;
    my $t    = $self->t;

    # Login
    $self->admin_loged_in;

    $t->get_ok('/admin/product/delete/1')->status_is(200);
}

__PACKAGE__->runtests;
