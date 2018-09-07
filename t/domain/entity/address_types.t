use Mojo::Base -strict;
use Test::More;
use Yetie::Domain::Factory;

my $pkg = 'Yetie::Domain::Entity::AddressTypes';
use_ok $pkg;

my $construct = sub { Yetie::Domain::Factory->new('entity-address_types')->create(shift) };
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
