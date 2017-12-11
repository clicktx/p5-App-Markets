use Mojo::Base -strict;
use t::Util;
use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('App');

subtest 'method build()' => sub {
    my $f = $t->app->factory('entity-staff');
    my $e = $f->build();
    ok !$e->has_data, 'right argument empty';

    $f = $t->app->factory('entity-staff');
    $e = $f->build(222);
    isa_ok $e, 'Yetie::Domain::Entity::Staff', 'right build by id';

    $f = $t->app->factory('entity-staff');
    $e = $f->build('staff');
    is $e->id, 223, 'right build by email';

    $f = $t->app->factory('entity-staff');
    $e = $f->build(999);
    ok !$e->has_data, 'right not found ID';

    $f = $t->app->factory('entity-staff');
    $e = $f->build('foobar');
    ok !$e->has_data, 'right not found login_id';
};

done_testing;
