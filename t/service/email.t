package t::service::email;

use Mojo::Base 't::common';
use t::Util;
use Test::More;
use Test::Mojo;

sub _init {
    my $self = shift;
    my $c    = $self->t->app->build_controller;
    return ( $c, $c->service('email') );
}

sub t00_startup : Tests(startup) { shift->app->routes->any('/:controller/:action')->to() }

sub t01_find_email : Tests() {
    my $self = shift;
    my ( $c, $s ) = $self->_init;

    my $e = $s->find_email('c@example.org');
    isa_ok $e, 'Yetie::Domain::Value::Email';
    ok $e->in_storage,  'right in storage';
    ok $e->is_verified, 'right verified';

    $e = $s->find_email('g@example.org');
    isa_ok $e, 'Yetie::Domain::Value::Email';
    ok $e->in_storage, 'right in storage';
    ok !$e->is_verified, 'right not verified';

    $e = $s->find_email('foo@bar.baz');
    isa_ok $e, 'Yetie::Domain::Value::Email';
    ok !$e->in_storage, 'right not in storage';
    ok !$e->is_verified, 'right not verified';
}

__PACKAGE__->runtests;
