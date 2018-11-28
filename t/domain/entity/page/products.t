use Mojo::Base -strict;
use Test::More;
use Yetie::Domain::Collection qw(c);

my $pkg = 'Yetie::Domain::Entity::Page::Products';
use_ok $pkg;

subtest 'basic' => sub {
    my $e = $pkg->new();
    isa_ok $e, 'Yetie::Domain::Entity::Page';
    isa_ok $e->product_list, 'Yetie::Domain::List::Products';
};

done_testing();
