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

subtest 'add' => sub {
    my $price = $pkg->new(100);
    my $res   = $price + 1;
    ok $res->value == 101, 'right add int';

    $res = $price + $price;
    ok $res->value == 200, 'right add obj';

    my $jpy = $pkg->new( value => 100, currency_code => 'JPY' );
    dies_ok { $price + $jpy } 'right different currency';

    my $incl_tax = $pkg->new( value => 100, is_tax_included => 1 );
    dies_ok { $price + $incl_tax } 'right different including tax';
};

subtest 'multiply' => sub {
    my $price = $pkg->new(100);
    my $res   = $price * 1;
    ok $res->value == 100, 'right multiply int';

    $res = $price * $price;
    ok $res->value == 10000, 'right multiply obj';
};

subtest 'subtract' => sub {
    my $price = $pkg->new(100);
    my $res   = $price - 1;
    ok $res->value == 99, 'right subtract int';

    $res = $price - $price;
    ok $res->value == 0, 'right subtract obj';
};

done_testing();
