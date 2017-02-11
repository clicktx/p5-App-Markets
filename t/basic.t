use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t   = Test::Mojo->new('App');
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

    eval { $db->merge_schema( ['t::DB::NoSchema'] ) };
    like $@, qr/Can't locate object method "instance" via package/,
      'no has schema';

    $db->merge_schema( ['t::DB::Schema'] );
    my $table = $db->schema->get_table('test');
    is_deeply $table->{columns}, [qw/id key_name value/], 'right merged schema';
};

done_testing();
