use Mojo::Base -strict;
use t::Util;
use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('App');

subtest 'method build()' => sub {
    my $f = $t->app->factory('entity-customer');
    my $e = $f->build();
    ok !$e->has_data, 'right argument empty';

    $f = $t->app->factory('entity-customer');
    $e = $f->build(111);
    isa_ok $e, 'Yetie::Domain::Entity::Customer', 'right build by id';

    $f = $t->app->factory('entity-customer');
    $e = $f->build('c@x.org');
    is $e->id, 111, 'right build by email';

    $f = $t->app->factory('entity-customer');
    $e = $f->build(999);
    ok !$e->has_data, 'right not found ID';

    $f = $t->app->factory('entity-customer');
    $e = $f->build('xx@xx.org');
    ok !$e->has_data, 'right not found email';
};

done_testing;
