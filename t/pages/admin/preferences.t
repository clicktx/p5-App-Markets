package t::pages::admin::preferences;

use Mojo::Base 't::pages::common';
use t::Util;
use Test::More;
use Test::Mojo;

sub update_value : Tests() {
    my $self = shift;
    my $t    = $self->t;

    # Login
    $self->admin_loged_in;

    my $post_data = {
        csrf_token            => $self->csrf_token,
        customer_password_min => 16
    };
    $t->post_ok( '/admin/preferences', form => $post_data )->status_is(200);
    is $t->app->pref('customer_password_min'), 16;
}

__PACKAGE__->runtests;
