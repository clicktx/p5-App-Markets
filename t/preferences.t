use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t   = Test::Mojo->new('App');
my $app = $t->app;

my $pref = $app->model('data')->load_pref;
is ref $pref, 'HASH', 'right loading preferences';

$app->stash('pref')->{ADMIN_PAGE_PREFIX} = '/admin';
my $value = $app->pref('ADMIN_PAGE_PREFIX');
is $value, '/admin', 'right set value';

eval { $value = $app->pref('PREF_KEY'); };
like $@, qr/pref\('PREF_KEY'\) has not value/, 'right fatal';

# TODO: 後でsetterを作る。基本的には不要かも？
# $app->pref( PREF_KEY => 'new value', ... );

$app->stash('pref')->{PREF_KEY} = 'new value';
$value = $app->pref('PREF_KEY');
is $value, 'new value', 'right set value';

$app->stash('pref')->{PREF_KEY} = [ 1, 2, 3 ];
$value = $app->pref('PREF_KEY');
is ref $value, 'ARRAY', 'right rewrite';
is_deeply $value, [ 1, 2, 3 ], 'right rewrite';

done_testing();
