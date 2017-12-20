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

done_testing();
