use Mojo::Base -strict;
use t::Util;
use Test::More;
use Test::Mojo;

use_ok 'Markets::Domain::Factory::Entity::Customer';

my $t = Test::Mojo->new('App');
my $f = $t->app->factory('entity-customer');

subtest 'method build()' => sub {
    my $e = $f->build();
    ok !$e, 'right argument empty';

    $e = $f->build(111);
    isa_ok $e, 'Markets::Domain::Entity::Customer', 'right build by id';

    $e = $f->build('c@x.org');
    is $e->id, 111, 'right build by email';

    $e = $f->build(999);
    is $e, undef, 'right not found ID';

    $e = $f->build('xx@xx.org');
    is $e, undef, 'right not found email';
};

done_testing;
