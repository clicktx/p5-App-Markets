use Mojo::Base -strict;
use t::Util;
use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('App');
my $f = $t->app->factory('entity-staff');

subtest 'method build()' => sub {
    my $e = $f->build();
    ok !$e, 'right argument empty';

    $e = $f->build(222);
    isa_ok $e, 'Yetie::Domain::Entity::Staff', 'right build by id';

    $e = $f->build('staff');
    is $e->id, 223, 'right build by email';

    $e = $f->build(999);
    is $e, undef, 'right not found ID';

    $e = $f->build('foobar');
    is $e, undef, 'right not found login_id';
};

done_testing;
