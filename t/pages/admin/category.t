package t::pages::admin::category;

use Mojo::Base 't::common';
use t::Util;
use Test::More;
use Test::Mojo;

sub t00_login : Tests() { shift->admin_loggin }

sub t01_index : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $t->get_ok('/admin/category')->status_is(200);

    my $post_data = {
        csrf_token => $self->csrf_token,
        title      => 'foo',
        parent_id  => 0,                   # create root category
    };
    $t->post_ok( '/admin/category', form => $post_data )->status_is( 200, 'right create new category' );
    $t->post_ok( '/admin/category', form => $post_data )->status_is( 409, 'right title same name exists' );
}

sub t02_edit : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $t->get_ok('/admin/category/1/edit')->status_is(200);
    $t->get_ok('/admin/category/999/edit')->status_is(404);
}

__PACKAGE__->runtests;
