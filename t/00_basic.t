use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

subtest 'front page' => sub {
    my $t = Test::Mojo->new('Markets::Web');
    $t->get_ok('/')->status_is(200)->content_like(qr/Mojolicious/i);
};

subtest 'admin page' => sub {
    my $t = Test::Mojo->new('Markets::Admin');
    $t->get_ok('/')->status_is(200)->content_like(qr/Admin/i);
};

subtest 'utility' => sub {
    use_ok 'Markets::Util';
    my $themes = Markets::Util->new->list_themes('theme');
    is_deeply $themes, ['theme/mytheme'];
};

done_testing();
