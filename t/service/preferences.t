use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t   = Test::Mojo->new('App');
my $app = $t->app;

use_ok 'Yetie::Service::Preference';
my $pref = $app->service('preference');

can_ok $pref, 'load';
can_ok $pref, 'store';

subtest 'store' => sub {
    ok !$pref->store, 'unmodified preference(s)';

    $app->pref( pref_test1 => 1, pref_test2 => 2 );
    ok $pref->store, 'modified preference(s)';
    my $resultset = $app->schema->resultset('Preference');
    is $resultset->find( { name => 'pref_test1' } )->value, 1, 'right update DB';
    is $resultset->find( { name => 'pref_test2' } )->value, 2, 'right update DB';
};

done_testing();

__END__
subtest 'Basic' => sub {
    isa_ok $model->load_pref, 'HASH', 'right load preferences';
    isa_ok $model->value,     'HASH', 'right value method';
    is $model->value('not_key'),    undef,    'right not found key';
    is $model->value('addons_dir'), 'addons', 'right getter';

    is $model->_store_pref(), undef, 'not argument';
    is $model->_store_pref('hoge'), undef, 'illegal argument';
    is $model->value( hoge => 1 ), 0, 'not found key';
    is $model->value( hoge      => 1, huga => 1 ), 0, 'not found key';
    is $model->value( admin_dir => 1, hoge => 1 ), 0, 'right update';

    is $model->value( admin_uri_prefix => 1, addons_dir => 2 ), 1, 'right update';
    is $app->pref('admin_uri_prefix'), 1, 'right preference value';
    is $app->pref('addons_dir'),       2, 'right preference value';

    # reload preferences from DB
    $app->defaults('pref')->{'addons_dir'} = 1;
    is $app->pref('addons_dir'), 1;
    isa_ok $model->reload_pref, 'HASH', 'right reload prefereces';
    is $app->pref('addons_dir'), 2;

    # 他のテストのために値を戻しておく
    is $model->value( admin_uri_prefix => undef, addons_dir => undef ), 1, 'right reset prefereces';
    $model->reload_pref;
};

subtest 'Helper' => sub {
    my $value;
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
};

# Default values
subtest 'Default values' => sub {
    is $app->pref('admin_uri_prefix'), '/admin', 'right admin_uri_prefix';
    is $app->pref('addons_dir'),       'addons', 'right addons_dir';
};

done_testing();
