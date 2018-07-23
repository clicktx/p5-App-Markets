use Mojo::Base -strict;
use Test::More;

my $pkg = 'Yetie::Domain::Value::Phone';
use_ok $pkg;

subtest 'basic' => sub {
    my $phone = $pkg->new();
    isa_ok $phone, 'Yetie::Domain::Value';
};

subtest 'number_only' => sub {
    my $phone = $pkg->new();
    is $phone->number_only, '', 'right number only empty';

    $phone = $pkg->new( { value => '(012)234-5678' } );
    is $phone->number_only, '0122345678', 'right number only';

    $phone = $pkg->new( { value => '（０１２）２３４ー５６７８' } );
    is $phone->number_only, '０１２２３４５６７８', 'right number only double-byte characters';
};

done_testing();
