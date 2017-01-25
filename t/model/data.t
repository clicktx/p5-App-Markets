use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t   = Test::Mojo->new('App');
my $app = $t->app;

subtest 'Model Data Base' => sub {
    my $result = $app->model('Data::Base')->new;
    ok( ref $result, 'right' );
};

subtest 'preferences' => sub {
    my $result = $app->model('data')->load_pref;
    isa_ok( $result, 'HASH' );
};

done_testing();
