use Mojo::Base -strict;
use Test::More;
use Yetie::Factory;

my $pkg = 'Yetie::Domain::List::AddressTypes';
use_ok $pkg;

my $construct = sub { Yetie::Factory->new('list-address_types')->construct(shift) };
my $data = {
    list => [
        { id => 1, name => 'foo' },
        { id => 2, name => 'bar' },
        { id => 3, name => 'baz' },
        { id => 4, name => 'qux' },
    ]
};

subtest 'basic' => sub {
    my $e = $construct->( {} );
    isa_ok $e, $pkg;
};

subtest 'get_id_by_name' => sub {
    my $e = $construct->($data);
    is $e->get_id_by_name('bar'), 2, 'right id';
};

done_testing();
