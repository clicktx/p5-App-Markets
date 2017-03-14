use Mojo::Base -strict;
use Test::More;

use_ok 'Markets::Entity';

subtest 'Entity object base' => sub {
    my $e1   = Markets::Entity::Hoge->new( entity_id => 1 );
    my $e1_1 = Markets::Entity::Hoge->new( entity_id => 1 );
    my $e2   = Markets::Entity::Fuga->new( entity_id => 2 );

    is $e1->id, 1, 'right entity id';
    is $e1->is_equal($e1_1), 1, 'right equal object';
    is $e1->is_equal($e2),   0, 'right not equal object';
    is $e1->hash_code, '356a192b7913b04c54574d18c28d46e6395428ab', 'right hash code';
};

done_testing();

package Markets::Entity::Hoge;
use Mojo::Base 'Markets::Entity';
1;

package Markets::Entity::Fuga;
use Mojo::Base 'Markets::Entity';
1;
