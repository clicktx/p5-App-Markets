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

    subtest login_process => sub {
        my %csrf = ( csrf_token => $self->csrf_token );

        # right not argument
        $t->post_ok( '/test/login_process', form => { %csrf, email => '', password => '' } )->status_is(401)
          ->json_is( { customer_id => undef } );

        # right not found customer
        $t->post_ok( '/test/login_process', form => { %csrf, email => 'foo-bar@baz.com', password => '11111111' } )
          ->status_is(401)->json_is( { customer_id => undef } );

        # right password failure
        $t->post_ok( '/test/login_process', form => { %csrf, email => 'c@example.org', password => '11111111' } )
          ->json_is( { customer_id => undef } );

        # right accept password
        $t->post_ok( '/test/login_process', form => { %csrf, email => 'c@example.org', password => '12345678' } )
          ->status_is(200)->json_is( { customer_id => 111 } );
    };
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

sub t04_get_address_list : Tests() {
    my $self = shift;
    my ( $c, $s ) = $self->_init();

    my $e = $s->get_address_list(112);
    isa_ok $e, 'Yetie::Domain::List::Addresses';
    is $e->list->size, 1, 'right addresses';

    $e = $s->get_address_list(999);
    is $e->list->size, 0, 'right not found customer';
}

sub t05_remember_me : Tests() {
    my $self = shift;
    my ( $c, $s ) = $self->_init();

    ok !$s->remember_me, 'right getter';
    ok $s->remember_me('foo@bar.baz'), 'right setter';
    is $c->tx->res->cookies->[0]->name, 'remember_me', 'right set cookie';
}

sub t06_search_customers : Tests() {
    my $self = shift;
    my ( $c, $s ) = $self->_init();

    my $form = $c->form('search');
    $form->do_validate;

    my $e = $s->search_customers($form);
    isa_ok $e, 'Yetie::Domain::Entity::Page::Customers';
}

sub t07_send_authorization_mail : Tests() {
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
        my $res = $s->store_address(1);
        ok !$res, 'right no data';

        $c->server_session->customer_id(115);
        $res = $s->store_address(1);
        ok $res, 'right store address';

        $res = $s->store_address(1);
        ok !$res, 'right stored address';
    };
    $c->render( text => 1 );
}

sub login_process {
    my $c = shift;
    my $s = $c->service('customer');
    my $f = $c->form('account-login');
    $f->do_validate;

    my $customer_id = $s->login_process($f);
    $c->render( json => { customer_id => $customer_id } );
}

done_testing();
