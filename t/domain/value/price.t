use Mojo::Base -strict;
use Test::More;
use Test::Exception;

my $pkg = 'Yetie::Domain::Value::Price';
use_ok $pkg;

subtest 'basic' => sub {
    dies_ok { $pkg->new( value => -1 ) } 'right dies';
    lives_ok { $pkg->new( value => 1 ) } 'right lives';
    lives_ok { $pkg->new( value => 0.1 ) } 'right lives';

    my $price = $pkg->new( value => 100, round_mode => 'even' );
    is $price->amount / 7, '$14.29', 'right defaylt round mode';

    $price = $pkg->new( value => 100, round_mode => 'trunc' );
    is $price->amount / 7, '$14.28', 'right change round mode';
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

subtest 'add_in_place' => sub {
    my $price = $pkg->new(100);
    my $p2    = $price;
    $p2 += 1;
    ok $p2->value == 101, 'right add in place';

    $price += $p2;
    ok $price->value == 201, 'right add in place object';

    my $jpy = $pkg->new( value => 100, currency_code => 'JPY' );
    dies_ok { $jpy += $price } 'right different currency';

    my $incl_tax = $pkg->new( value => 100, is_tax_included => 1 );
    dies_ok { $incl_tax += $price } 'right different including tax';
};

subtest 'divide' => sub {
    my $price = $pkg->new( value => 100, round_mode => 'even' );
    my $res = $price / 1;
    ok $res->value == 100, 'right divide int';

    $res = $price / $price;
    ok $res->value == 1, 'right divide obj';

    $res = $price / 7;
    ok $res->value == 14.29, 'right divide round';
};

subtest 'divide_in_place' => sub {
    my $price = $pkg->new( value => 100, round_mode => 'even' );
    my $p2 = $price;
    $p2 /= 2;
    ok $p2->value == 50, 'right divide in place';

    $price /= $p2;
    ok $price->value == 2, 'right divide in place object';

    $price /= 3;
    ok $price->value == 0.67, 'right divide round';
};

subtest 'modulo' => sub {
    my $price = $pkg->new(10);
    my $res   = $price % 7;
    ok $res->value == 3, 'right modulo int';

    my $res2 = $price % $res;
    ok $res2->value == 1, 'right modulo object';
};

subtest 'modulo_in_place' => sub {
    my $price = $pkg->new(10);
    my $p2    = $price;
    $p2 %= 7;
    ok $p2->value == 3, 'right modulo in place';

    $price %= $p2;
    ok $price->value == 1, 'right modulo in place object';
};

subtest 'multiply' => sub {
    my $price = $pkg->new(100);
    my $res   = $price * 1;
    ok $res->value == 100, 'right multiply int';

    $res = $price * $price;
    ok $res->value == 10000, 'right multiply obj';
};

subtest 'multiply_in_place' => sub {
    my $price = $pkg->new(100);
    my $p2    = $price;
    $p2 *= 2;
    ok $p2->value == 200, 'right multiply in place';

    $price *= $p2;
    ok $price->value == 20000, 'right multiply in place object';
};

subtest 'subtract' => sub {
    my $price = $pkg->new(100);
    my $res   = $price - 1;
    ok $res->value == 99, 'right subtract int';

    $res = $price - $price;
    ok $res->value == 0, 'right subtract obj';
};

subtest 'subtract_in_place' => sub {
    my $price = $pkg->new(100);
    my $p2    = $price;
    $p2 -= 1;
    ok $p2->value == 99, 'right subtract in place';

    $price -= $p2;
    ok $price->value == 1, 'right subtract in place object';
};

subtest 'compares' => sub {
    my $price = $pkg->new(10);
    ok $price > 9, 'right greater';
    ok !$price < 9, 'right less';
    ok $price < 11, 'right less';
    ok $price >= 10, 'right not less';
    ok $price <= 10, 'right not greater';

    my $p2 = $pkg->new(9);
    ok $price > $p2, 'right greater';
    ok !( $price < $p2 ), 'right less';
    my $p3 = $pkg->new(11);
    ok $price < $p3, 'right less';
    my $p4 = $pkg->new(10);
    ok $price >= $p4, 'right not less';
    ok $price <= $p4, 'right not greater';

    ok $price == $p4, 'right equals';
    ok $price != $p3, 'right not equals';

    my $jpy = $pkg->new( value => 100, currency_code => 'JPY' );
    dies_ok { $jpy > $price } 'right different currency';
    dies_ok { $jpy < $price } 'right different currency';
    dies_ok { $jpy >= $price } 'right different currency';
    dies_ok { $jpy <= $price } 'right different currency';
    dies_ok { $jpy == $price } 'right different currency';
    dies_ok { $jpy != $price } 'right different currency';

    my $incl_tax = $pkg->new( value => 100, is_tax_included => 1 );
    dies_ok { $incl_tax > $price } 'right different including tax';
    dies_ok { $incl_tax < $price } 'right different including tax';
    dies_ok { $incl_tax >= $price } 'right different including tax';
    dies_ok { $incl_tax <= $price } 'right different including tax';
    dies_ok { $incl_tax == $price } 'right different including tax';
    dies_ok { $incl_tax != $price } 'right different including tax';
};

done_testing();
