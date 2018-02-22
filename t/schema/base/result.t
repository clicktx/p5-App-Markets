use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t      = Test::Mojo->new('App');
my $app    = $t->app;
my $schema = $app->schema;
my $rs     = $schema->resultset('Preference');

subtest 'choose_column_name' => sub {
    my $result = $rs->search()->first;
    my @array  = $result->choose_column_name();
    is @array, 8, 'right array';

    my $array = $result->choose_column_name();
    is ref $array, 'ARRAY', 'right array refference';

    $array = $result->choose_column_name( columns => [] );
    is_deeply $array, [], 'right no colmuns';

    @array = $result->choose_column_name( columns => [qw(id name)] );
    @array = sort @array;
    is_deeply \@array, [qw(id name)], 'right option colmuns';

    @array = $result->choose_column_name( ignore_columns => [] );
    is @array, 8, 'right option ignore_colmuns no values';

    @array = $result->choose_column_name( ignore_columns => [qw(default_value id position title)] );
    @array = sort @array;
    is_deeply \@array, [qw(group_id name summary value)], 'right option ignore_colmuns';
};

subtest 'method to_data()' => sub {
    my $rs     = $schema->resultset('Sales');
    my $result = $rs->search()->first->to_data;

    is $result->{id},             1;
    is $result->{customer_id},    111;
    is $result->{address_id},     1;
    isa_ok $result->{created_at}, 'DateTime';
};

subtest 'method to_hash()' => sub {

    subtest 'basic' => sub {
        my $result = $rs->search()->first;
        my $hash   = $result->to_hash;
        is ref $hash, 'HASH', 'right variable type';
        is_deeply $hash,
          {
            default_value => '/admin',
            group_id      => 1,
            id            => 1,
            name          => 'admin_uri_prefix',
            position      => 100,
            summary       => 'pref.summary.admin_uri_prefix',
            title         => 'pref.title.admin_uri_prefix',
            value         => undef,
          },
          'right data';
    };

    subtest 'options' => sub {
        my $result = $rs->search()->first;
        my $ignore = $result->to_hash( ignore_columns => [qw( default_value id position summary title)] );
        is_deeply $ignore, { group_id => 1, name => 'admin_uri_prefix', value => undef }, 'right ignore columns';

        my $consider = $result->to_hash( columns => [qw(id position)] );
        is_deeply $consider, { id => 1, position => 100 }, 'right pick on columns';
    };
};

done_testing();
