use Mojo::Base -strict;
use Test::More;
use Test::Exception;

my $pkg = 'Yetie::Domain::Value::Price';
use_ok $pkg;

subtest 'basic' => sub {
    dies_ok { $pkg->new( value => -1 ) } 'right dies';
    lives_ok { $pkg->new( value => 1 ) } 'right lives';
    lives_ok { $pkg->new( value => 0.1 ) } 'right lives';
};

subtest 'amount' => sub {
    my $price = $pkg->new(100);
    is $price->amount, '$100.00', 'right amount';
    is $price, '$100.00', 'right operator';
};

subtest 'is_tax_included' => sub {
    my $price = $pkg->new();
    ok !$price->is_tax_included, 'right default';

    $price = $pkg->new( is_tax_included => 1 );
    ok $price->is_tax_included, 'right tax included';
};

done_testing();
