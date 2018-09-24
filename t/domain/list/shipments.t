use Mojo::Base -strict;
use Test::More;
use Test::Deep;
use Yetie::Domain::Factory;

my $pkg = 'Yetie::Domain::List::Shipments';
use_ok $pkg;

sub construct {
    Yetie::Domain::Factory->new('list-shipments')->construct(@_);
}

subtest 'basic' => sub {
    my $v = construct();
    isa_ok $v, 'Yetie::Domain::List';
};

subtest 'has_shipment' => sub {
    my $v    = construct();
    my $bool = $v->has_shipment;
    is $bool, 0, 'right has not shipment';

    $v = construct( list => [ {} ] );
    $bool = $v->has_shipment;
    is $bool, 1, 'right has shipment';
};

subtest 'is_multiple' => sub {
    my $v    = construct();
    my $bool = $v->is_multiple;
    is $bool, 0, 'right not set shipments';

    $v = construct( list => [ {} ] );
    $bool = $v->is_multiple;
    is $bool, 0, 'right single shipment';

    $v = construct( list => [ {}, {} ] );
    $bool = $v->is_multiple;
    is $bool, 1, 'right multiple shipments';
};

subtest 'total_quantity' => sub {
    my $v = construct( list => [ { items => [ { quantity => 1 }, { quantity => 2 } ] } ] );
    is $v->total_quantity, 3, 'right total quantity';
};

subtest 'revert' => sub {
    my $v = construct();
    is $v->revert, undef, 'right not has shipment';

    $v = construct( list => [ { shipping_address => { postal_code => 12345 }, items => [ { quantity => 1 } ] } ] );
    $v->revert;
    my $data = $v->to_data;
    is $data->[0]->{shipping_address}->{postal_code}, 12345, 'right shipping_address in first element';
    cmp_deeply $data, [ { shipping_address => ignore(), items => [] } ], 'right revert';
};

done_testing();
