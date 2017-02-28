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
    $t->get_ok('/admin')->status_is(302);
};

subtest 'utility' => sub {
    use_ok 'Markets::Util';
    my $themes = Markets::Util::directories( 'themes',
        { ignore => [ 'default', 'admin' ] } );
    is_deeply $themes, ['mytheme'], 'loading mytheme';

    my $addons = Markets::Util::directories('addons');
    is ref $addons, 'ARRAY', 'loading addons';
};

done_testing();
