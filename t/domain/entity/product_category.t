use Mojo::Base -strict;
use Test::More;

use_ok 'Yetie::Domain::Entity::ProductCategory';

subtest 'default attributes' => sub {
    my $o = Yetie::Domain::Entity::ProductCategory->new();

    isa_ok $o, 'Yetie::Domain::Entity', 'right customer';

    can_ok $o, 'id';
    can_ok $o, 'category_id';
    can_ok $o, 'is_primary';
    can_ok $o, 'title';
};

subtest 'to_hash' => sub {
    my $o = Yetie::Domain::Entity::ProductCategory->new();
    is_deeply $o->to_hash,
      {
        category_id => 0,
        id          => 0,
        is_primary  => 0,
      },
      'right remove title';
};

done_testing();
