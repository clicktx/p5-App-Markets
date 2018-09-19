use Mojo::Base -strict;
use Test::More;

use_ok 'Yetie::Util';

subtest 'directories' => sub {
    my $themes = Yetie::Util::directories( 'themes', { ignore => [ 'admin', 'common', 'default' ] } );
    is_deeply $themes, ['mytheme'], 'loading mytheme';

    my $addons = Yetie::Util::directories('addons');
    is ref $addons, 'ARRAY', 'loading addons';
};

done_testing();
