use Mojolicious::Lite;
use Test::More;
use Test::Mojo;

plugin 'Model' => { namespace => ['Markets::Model'] };

get '/hoge' => sub {
    my $c = shift;
    $c->model('domain');
    $c->render( text => '1' );
};

my $t = Test::Mojo->new;
$t->get_ok('/hoge');

done_testing();
