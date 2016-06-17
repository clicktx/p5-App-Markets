use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('Markets::Web');

subtest 'front page' => sub {
    $t->get_ok('/')->status_is(200)->content_like(qr/Mojolicious/i);
};

subtest 'admin page' => sub {
    $t->get_ok('/admin')->status_is(200)->content_like(qr/Admin Mode/i);
};

subtest 'utility' => sub {
    use_ok 'Markets::Util';
    my $themes = Markets::Util::directories( 'theme',
        { ignore => [ 'default', 'admin' ] } );
    is_deeply $themes, ['mytheme'];

    my $addons = Markets::Util::directories('addons');
    is ref $addons, 'ARRAY';
};

done_testing();
