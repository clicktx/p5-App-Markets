use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

subtest 'app access' => sub {
    my $t = Test::Mojo->new('Markets::Web');
    $t->get_ok('/')->status_is(200)->content_like(qr/Mojolicious/i);
};


subtest 'lise subthemes' => sub {
    use_ok 'Markets::Util';
    my $themes = Markets::Util->new->list_themes('theme');
    is_deeply $themes, ['theme/mytheme'];
};

done_testing();
