use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;
use Test::Deep;

my $t      = Test::Mojo->new('App');
my $app    = $t->app;
my $schema = $app->schema;
my $rs     = $schema->resultset('Customer');

subtest 'find_by_id' => sub {
    my $res = $rs->find_by_id(111);
    cmp_deeply $res->{related_resultsets},
      {
        emails            => ignore(),
        customer_password => ignore(),
      },
      'right related_resultsets';

    $res = $rs->find_by_id(999);
    ok !$res;
};

subtest 'find_by_email' => sub {
    my $res = $rs->find_by_email('c@example.org');
    is $res->id, 111, 'right id';
    cmp_deeply $res->{related_resultsets},
      {
        emails            => ignore(),
        customer_password => ignore(),
      },
      'right related_resultsets';

    $res = $rs->find_by_email('g@example.org');
    isnt $res->id, 111, 'right other customer';

    $res = $rs->find_by_email('xx@xx.org');
    ok !$res, 'right not found';
};

subtest 'get_id_by_email' => sub {
    my $customer_id = $rs->get_id_by_email('c@example.org');
    is $customer_id, 111, 'right get id';

    $customer_id = $rs->get_id_by_email('xx@xx.org');
    is $customer_id, undef, 'right no found';
};

subtest 'last_loged_in_now' => sub {
    my $last_loged_in_at = $rs->find(111)->last_logged_in_at;

    $rs->last_loged_in_now(111);
    isnt $last_loged_in_at, $rs->find(111)->last_logged_in_at, 'right update last loged in';

    is $rs->last_loged_in_now(999), undef, 'right not found customer';
};

subtest 'search_by_id' => sub {
    my @res = $rs->search_by_id(111);
    is @res, 1, 'right search by id';

    @res = $rs->search_by_id(999);
    ok !@res, 'right not found';
};

subtest 'search_by_email' => sub {
    my @res = $rs->search_by_email('c@example.org');
    is @res, 1, 'right search by email';

    @res = $rs->search_by_email('xx@xx.org');
    ok !@res, 'right not found';
};

subtest 'search_customers' => sub {
    my $itr = $rs->search_customers(
        {
            where    => '',
            order_by => '',
            page_no  => 1,
            per_page => 3,
        }
    );

    isa_ok $itr, 'Yetie::Schema::ResultSet::Customer';
    is $itr->count, 3, 'right per page';
};

done_testing();
