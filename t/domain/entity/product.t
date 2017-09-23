use Mojo::Base -strict;
use Test::More;

use_ok 'Markets::Domain::Entity::Product';

subtest 'basic' => sub {
    my $p = Markets::Domain::Entity::Product->new();
    isa_ok $p, 'Markets::Domain::Entity';

    can_ok $p, 'title';
    can_ok $p, 'description';
    can_ok $p, 'price';
    can_ok $p, 'primary_category';
    can_ok $p, 'product_categories';
    can_ok $p, 'created_at';
    can_ok $p, 'updated_at';

    isa_ok $p->primary_category,   'Markets::Domain::Collection';
    isa_ok $p->product_categories, 'Markets::Domain::Collection';
};

done_testing();
