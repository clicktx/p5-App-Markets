package t::service::customer;

use Mojo::Base 't::pages::common';
use t::Util;
use Test::More;
use Test::Mojo;

sub _init {
    my $self       = shift;
    my $controller = $self->app->build_controller;
    my $service    = $controller->service('customer');
    return ( $controller, $service );
}

sub t00_startup : Tests(startup) { shift->app->routes->any('/:controller/:action')->to() }

sub t01 : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $t->get_ok('/test/store_address')->status_is(200);
    $t->get_ok('/test/login_process');
}

sub t02_create_new_customer : Tests() {
    my $self = shift;
    my ( $c, $s ) = $self->_init();

    my $new_customer = $s->create_new_customer('new_customer_on_service@example.com');
    isa_ok $new_customer, 'Yetie::Domain::Entity::Customer';
    ok $new_customer->id, 'right id';

    $new_customer = $s->create_new_customer('new_customer_on_service@example.com');
    is $new_customer, undef, 'right duplicated';
}

sub t03_find_customer : Tests() {
    my $self = shift;
    my ( $c, $s ) = $self->_init();

    my $entity = $s->find_customer('foo@bar.baz');
    isa_ok $entity, 'Yetie::Domain::Entity::Customer';
    is $entity->id, undef, 'right nonexists';

    $entity = $s->find_customer('a@example.org');
    is $entity->id, 111, 'right customer';
}

sub t04_get_addresses : Tests() {
    my $self = shift;
    my ( $c, $s ) = $self->_init();

    my $e = $s->get_addresses( 112, 'shipping_address' );
    isa_ok $e, 'Yetie::Domain::List::Addresses';
    is $e->list->size, 1, 'right shipping addresses';

    $e = $s->get_addresses( 112, 'billing_address' );
    is $e->list->size, 1, 'right billing addresses';

    $e = $s->get_addresses( 112, 'foo' );
    is $e->list->size, 0, 'right bad address type name';
}

sub t05_send_authorization_mail : Tests() {
    my $self = shift;
    my ( $c, $s ) = $self->_init();

    $s->send_authorization_mail('foo-bar@exapmle.org');
    like $c->session('new_flash')->{callback_url}->to_string, qr|/signup/get-started|, 'right singup';

    $s->send_authorization_mail('a@example.org');
    like $c->session('new_flash')->{callback_url}->to_string, qr|/login/token|, 'right login';
}

__PACKAGE__->runtests;

package Yetie::Controller::Catalog::Test;
use Mojo::Base 'Yetie::Controller::Catalog';
use Test::More;
use Test::Deep;

sub store_address {
    my $c = shift;
    my $s = $c->service('customer');

    subtest 'store_address' => sub {
        my $res = $s->store_address( 'billing_address', 1 );
        ok !$res, 'right no data';

        $c->server_session->customer_id(115);
        $res = $s->store_address( 'billing_address', 1 );
        ok $res, 'right store address';

        $res = $s->store_address( 'billing_address', 1 );
        ok !$res, 'right stored address';
    };
    $c->render( text => 1 );
}

sub login_process {
    my $c = shift;
    my $s = $c->service('customer');

    subtest 'login_process' => sub {
        ok !$s->login_process( '',                '' ),         'right not argument';
        ok !$s->login_process( 'foo-bar@baz.com', '' ),         'right not found customer';
        ok !$s->login_process( 'c@example.org',   '11223344' ), 'right password failure';

        ok $s->login_process( 'c@example.org', '12345678' ), 'right accept password';
        $c->server_session->customer_id, 111, 'right login';
    };
    $c->render( text => 1 );
}

done_testing();
