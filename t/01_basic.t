use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t   = Test::Mojo->new('Markets::Web');
my $app = $t->app;

subtest 'front page' => sub {
    $t->get_ok('/')->status_is(200)->content_like(qr/Mojolicious/i);
};

subtest 'admin page' => sub {
    $t->get_ok('/admin')->status_is(200)->content_like(qr/Admin/i);
};

subtest 'utility' => sub {
    use_ok 'Markets::Util';
    my $themes = Markets::Util::directories( 'themes',
        { ignore => [ 'default', 'admin' ] } );
    is_deeply $themes, ['mytheme'], 'loading mytheme';

    my $addons = Markets::Util::directories('addons');
    is ref $addons, 'ARRAY', 'loading addons';
};

subtest 'merge schema' => sub {
    my $db = $t->app->db;
    is ref $db, 'Markets::DB';

    eval { $db->merge_schema( ['t::Ex::NoSchema'] ) };
    like $@, qr/Can't locate object method "instance" via package/,
      'no has schema';

    $db->merge_schema( ['t::Ex::Schema'] );
    my $table = $db->schema->get_table('test');
    is_deeply $table->{columns}, [qw/id key value/], 'right merged schema';
};

subtest 'constants' => sub {
    $app->config('constants')->{ADMIN_PAGE_PREFIX} = '/admin';
    my $const_value = $app->const('ADMIN_PAGE_PREFIX');
    is $const_value, '/admin', 'right value';

    eval { $const_value = $app->const('NO_CONSTANT_KEY'); };
    like $@, qr/const\('NO_CONSTANT_KEY'\) has no constant value/, 'croak';

    $app->config('constants')->{NO_CONSTANT_KEY} = 'new value';
    $const_value = $app->const('NO_CONSTANT_KEY');
    is $const_value, 'new value', 'right value';

    $app->config('constants')->{NO_CONSTANT_KEY} = [ 1, 2, 3 ];
    $const_value = $app->const('NO_CONSTANT_KEY');
    is ref $const_value, 'ARRAY', 'right reference';
    is_deeply $const_value, [ 1, 2, 3 ], 'reght value';
};

done_testing();
