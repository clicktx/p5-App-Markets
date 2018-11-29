use Mojo::Base -strict;
use Test::More;

my $pkg = 'Yetie::Domain::Entity::Page::Customers';
use_ok $pkg;

subtest 'basic' => sub {
    my $e = $pkg->new();
    isa_ok $e, 'Yetie::Domain::Entity::Page';
    isa_ok $e->customer_list, 'Yetie::Domain::List::Customers';
};

done_testing();
