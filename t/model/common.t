use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t     = Test::Mojo->new('App');
my $app   = $t->app;
my $model = $app->model('common');

isa_ok $model->load_pref, 'HASH', 'right load preferences';
isa_ok $model->pref,      'HASH', 'right pref method';
is $model->pref('not_key'),    undef,    'right not found key';
is $model->pref('addons_dir'), 'addons', 'right getter';

is $model->_store_pref(), undef, 'not argument';
is $model->_store_pref('hoge'), undef, 'illegal argument';
is $model->pref( hoge => 1 ), 0, 'not found key';
is $model->pref( hoge      => 1, huga => 1 ), 0, 'not found key';
is $model->pref( admin_dir => 1, hoge => 1 ), 0, 'right update';

is $model->pref( admin_uri_prefix => 1, addons_dir => 2 ), 1, 'right update';
is $app->pref('admin_uri_prefix'), 1, 'right preference value';
is $app->pref('addons_dir'),       2, 'right preference value';

# 強制再読込
# $model->reload_pref;

# 他のテストのために値を戻しておく
$model->pref( admin_uri_prefix => '/admin', addons_dir => 'addons' ), 1, 'right update';

done_testing();
