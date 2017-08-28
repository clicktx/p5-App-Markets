use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t   = Test::Mojo->new('App');
my $app = $t->app;

my $r = $app->routes;
$r->any('/:controller/:action')->to();

# Requests
$t->get_ok('/test/create_customer')->status_is(200);

done_testing();

{

    package Markets::Controller::Catalog::Test;
    use Mojo::Base 'Markets::Controller::Catalog';
    use Test::More;

    sub create_customer {
        my $c = shift;
        my $customer;

        eval { $customer = $c->service('customer')->create_entity() };
        ok $@;

        $customer = $c->service('customer')->create_entity( email => 'name@domain.com' );
        is $customer->id, 3;

        $customer = $c->service('customer')->create_entity( customer_id => 3 );
        isa_ok $customer, 'Markets::Domain::Entity::Customer';

        # is $customer->....

        $c->render( text => 1 );
    }

}
