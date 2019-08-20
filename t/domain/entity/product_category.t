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

subtest 'full_title' => sub {

    my $ancestors = Yetie::Factory->new('list-category_trees')
      ->construct( list => [ { title => 'bar', id => 2 }, { title => 'foo', id => 1 } ] );
    my $o = construct(
        title     => 'me',
        ancestors => $ancestors,
    );
    is $o->full_title, 'foo > bar > me', 'right full title';
    is $o->full_title( { separator => '/' } ), 'foo / bar / me', 'right use option';

    $o = construct( title => 'me' );
    is $o->full_title, 'me', 'right top category title';

    $o = construct();
    is $o->full_title, q{}, 'right title none';
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
