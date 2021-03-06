use Mojo::Base -strict;
use Test::More;
use Test::Exception;
use Yetie::Factory;

my $pkg = 'Yetie::Domain::Entity::Activity';
use_ok $pkg;

subtest basic => sub {
    my $e = $pkg->new();
    isa_ok $e, 'Yetie::Domain::Entity';
};

subtest type => sub {
    my $e = $pkg->new();
    dies_ok { $e->type } 'right not set customer or staff ID';

    $e = $pkg->new( customer_id => 111 );
    is $e->type, 'customer', 'right type';

    $e = $pkg->new( staff_id => 111 );
    is $e->type, 'staff', 'right type';
};

subtest to_data => sub {
    my $e = $pkg->new();
    dies_ok { $e->to_data };

    $e = $pkg->new(
        action      => 'bar',
        customer_id => 111,
    );
    dies_ok { $e->to_data } 'right croak';

    $e = $pkg->new(
        customer_id => 111,
        method      => 'foo',
    );
    dies_ok { $e->to_data } 'right croak';

    $e = $pkg->new(
        action => 'bar',
        method => 'foo',
    );
    dies_ok { $e->to_data } 'right croak';
};

done_testing();
