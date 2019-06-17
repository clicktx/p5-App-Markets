use Mojo::Base -strict;
use Test::More;
use Yetie::Factory;

use_ok 'Yetie::Domain::Entity::ProductCategory';

sub construct { return Yetie::Factory->new('entity-product_category')->construct(@_) }

subtest 'default attributes' => sub {
    my $o = Yetie::Domain::Entity::ProductCategory->new( category_id => 111 );

    isa_ok $o, 'Yetie::Domain::Entity', 'right customer';

    can_ok $o, 'id';
    can_ok $o, 'ancestors';
    can_ok $o, 'category_id';
    can_ok $o, 'is_primary';
    can_ok $o, 'title';

    is $o->id, '111', 'right id';
};

subtest 'ancestors' => sub {
    my $o = construct( ancestors => [ { title => 'foo', id => 1 }, { title => 'bar', id => 2 } ] );
    isa_ok $o->ancestors, 'Yetie::Domain::List::CategoryAncestors';
    isa_ok $o->ancestors->first, 'Yetie::Domain::Entity::Category';
};

subtest 'to_hash' => sub {
    my $o = Yetie::Domain::Entity::ProductCategory->new( category_id => 222 );

    is_deeply $o->to_hash,
      {
        category_id => 222,
        is_primary  => 0,
      },
      'right to_hash';
};

done_testing();
