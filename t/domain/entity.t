use Mojo::Base -strict;
use Test::More;

use_ok 'Markets::Domain::Entity';

subtest 'basic' => sub {
    my $e = Markets::Domain::Entity->new( id => 1, hoge => 1, fuga => 2 );
    is_deeply $e->to_hash, { hoge => 1, fuga => 2 }, 'right to_hash';

    my $clone = $e->clone;
    isnt $e, $clone, 'right clone';
    is_deeply $e->to_hash, $clone->to_hash, 'right clone data structure';
};

subtest 'to_array method' => sub {
    my $data = { id => 1, hoge => 1, fuga => 2 };
    my $e = Markets::Domain::Entity->new($data);
    is_deeply $e->to_array, [ [qw/fuga hoge/], [qw/2 1/] ], 'right to_array';
};

subtest 'Entity object base' => sub {
    my $e1   = Markets::Domain::Entity::Hoge->new( id => 1 );
    my $e1_1 = Markets::Domain::Entity::Hoge->new( id => 1 );
    my $e2   = Markets::Domain::Entity::Fuga->new( id => 2 );

    is $e1->id, 1, 'right entity id';
    is $e1->is_equal($e1_1), 1, 'right equal object';
    is $e1->is_equal($e2),   0, 'right not equal object';
    is $e1->hash_code, '356a192b7913b04c54574d18c28d46e6395428ab', 'right hash code';

    eval { Markets::Domain::Entity::Hoge->new->id };
    like $@, qr/Attribute "id" not implemented by subclass/, 'right not set entity id';
};

done_testing();

package Markets::Domain::Entity::Hoge;
use Mojo::Base 'Markets::Domain::Entity';
1;

package Markets::Domain::Entity::Fuga;
use Mojo::Base 'Markets::Domain::Entity';
1;