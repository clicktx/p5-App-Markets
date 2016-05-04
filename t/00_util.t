use Mojo::Base -strict;
use Test::More;

use_ok 'Markets::Util';

subtest 'lise subthemes' => sub {
    my $themes = Markets::Util->new->list_themes('theme');
    is_deeply $themes, ['theme/mytheme'];
};

done_testing();
