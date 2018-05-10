use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;
use Test::Deep;

my $t      = Test::Mojo->new('App');
my $app    = $t->app;
my $schema = $app->schema;
my $rs     = $schema->resultset('Customer');

subtest 'method find_by_id()' => sub {
    my $res = $rs->find_by_id(111);
    cmp_deeply $res->{related_resultsets},
      {
        emails   => ignore(),
        password => ignore(),
      },
      'right related_resultsets';

    $res = $rs->find_by_id(999);
    ok !$res;
};

subtest 'method find_by_email()' => sub {
    my $res = $rs->find_by_email('c@example.org');
use DDP;p $res;
    is $res->id, 111, 'right id';
    cmp_deeply $res->{related_resultsets},
      {
        emails   => ignore(),
        password => ignore(),
      },
      'right related_resultsets';

    $res = $rs->find_by_email('g@example.org');
    isnt $res->id, 111, 'right other customer';

    $res = $rs->find_by_email('xx@xx.org');
    ok !$res, 'right not found';
};

subtest 'method get_id_by_email' => sub {
    my $customer_id = $rs->get_id_by_email('c@example.org');
    is $customer_id, 111, 'right get id';

    $customer_id = $rs->get_id_by_email('xx@xx.org');
    is $customer_id, undef, 'right no found';
};

subtest 'method search_by_id()' => sub {
    my @res = $rs->search_by_id(111);
    is @res, 1, 'right search by id';

    @res = $rs->search_by_id(999);
    ok !@res, 'right not found';
};

subtest 'method search_by_email()' => sub {
    my @res = $rs->search_by_email('c@example.org');
    is @res, 1, 'right search by email';

    @res = $rs->search_by_email('xx@xx.org');
    ok !@res, 'right not found';
};

done_testing();
