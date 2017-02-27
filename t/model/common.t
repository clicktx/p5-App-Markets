use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t   = Test::Mojo->new('App');
my $app = $t->app;

subtest 'load_pref' => sub {
    my $result = $app->model('common')->load_pref;
    isa_ok( $result, 'HASH' );
};

done_testing();
