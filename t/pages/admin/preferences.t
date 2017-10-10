package t::pages::admin::preferences;

use Mojo::Base 't::pages::common';
use t::Util;
use Test::More;
use Test::Mojo;

sub t00_login : Tests() { shift->admin_loged_in }

sub t01_index : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $t->get_ok('/admin/preferences')->status_is(200);
}

sub t02_update_value : Tests() {
    my $self = shift;
    my $t    = $self->t;

    my $post_data = {
        csrf_token            => $self->csrf_token,
        customer_password_min => 4
    };
    $t->post_ok( '/admin/preferences', form => $post_data )->status_is(200);
    is $t->app->pref('customer_password_min'), 4;
}

__PACKAGE__->runtests;
