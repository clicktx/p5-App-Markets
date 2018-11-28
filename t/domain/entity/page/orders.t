use Mojo::Base -strict;
use Test::More;

my $pkg = 'Yetie::Domain::Entity::Page::Orders';
use_ok $pkg;

subtest 'basic' => sub {
    my $e = $pkg->new();
    isa_ok $e, 'Yetie::Domain::Entity::Page';
    isa_ok $e->order_list, 'Yetie::Domain::List::OrderDetails';
};

done_testing();
