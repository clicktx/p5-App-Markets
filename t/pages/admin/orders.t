package t::pages::admin::orders;

use Mojo::Base 't::common';
use t::Util;
use Test::More;
use Test::Mojo;

sub t00_login : Tests() { shift->admin_logged_in }

sub t01_index : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $t->get_ok('/admin/orders')->status_is(200)->content_like(qr/Orders/);
}

__PACKAGE__->runtests;
