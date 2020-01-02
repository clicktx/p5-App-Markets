use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t   = Test::Mojo->new('App');
my $app = $t->app;

sub _init {
    my $c = $app->build_controller;
    return ( $c, $c->service('order') );
}

use_ok 'Yetie::Service::Order';

subtest 'find_order' => sub {
    my ( $c, $s ) = _init();

    my $o = $s->find_order(1);
    isa_ok $o, 'Yetie::Domain::Entity::OrderDetail';
    is $o->id, 1, 'right id';
};

subtest 'search_orders' => sub {
    my ( $c, $s ) = _init();

    my ( $e, $p ) = $s->search_orders();
    isa_ok $e, 'Yetie::Domain::List::OrderDetails';
    isa_ok $p, 'DBIx::Class::ResultSet::Pager';
};

done_testing();

__END__
