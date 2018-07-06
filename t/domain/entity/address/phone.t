use Mojo::Base -strict;
use Test::More;

my $pkg = 'Yetie::Domain::Entity::Address::Phone';
use_ok $pkg;

subtest 'basic' => sub {
    my $phone = $pkg->new();
    isa_ok $phone, 'Yetie::Domain::Entity';
};

subtest 'number_only' => sub {
    my $phone = $pkg->new();
    is $phone->number_only, '', 'right number only empty';

    $phone->number('(012)234-5678');
    is $phone->number_only, '0122345678', 'right number only';

    $phone->number('（０１２）２３４ー５６７８');
    is $phone->number_only, '０１２２３４５６７８', 'right number only double-byte characters';
};

done_testing();
