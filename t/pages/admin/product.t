package t::pages::admin::product;

use Mojo::Base 't::pages::common';
use t::Util;
use Test::More;
use Test::Mojo;

sub t01_not_logedin_request : Tests() {
    my $self = shift;
    my $t    = $self->t;

    my $routes = $self->app->routes->find('RN_admin_product')->children;
    my $paths = $self->make_path( $routes, { product_id => 1 } );

    $t->ua->max_redirects(0);
    foreach my $path ( @{$paths} ) {
        $t->get_ok($path)->status_is( 302, 'right redirect' );
    }
    $t->ua->max_redirects(1);
}

sub t02_login : Tests() { shift->admin_loged_in }

sub t03_get_request : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $t->get_ok('/admin/product/create')->status_is(200);
    $t->get_ok('/admin/product/1/duplicate')->status_is(200);
    $t->get_ok('/admin/product/1/edit')->status_is(200);
    $t->get_ok('/admin/product/1/edit/category')->status_is(200);
    $t->get_ok('/admin/product/999')->status_is(404);

    # delete
    $t->get_ok('/admin/product/3/delete')->status_is(200);
    $t->get_ok('/admin/product/999999/delete')->status_is(500);
}

sub t04_post_request : Tests() {
    my $self = shift;
    my $t    = $self->t;

    my $post_data = { csrf_token => $self->csrf_token };
    $t->post_ok( '/admin/product/100/edit/category', form => $post_data )->status_is(200);
}

__PACKAGE__->runtests;
