use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t   = Test::Mojo->new('App');
my $app = $t->app;

# routes
my $r = $app->routes->namespaces( ['Markets::Controller'] );
$r->find('RN_category_name_base')->remove;
$r->get('/hoge')->to('test#add');
$r->get('/fuga')->to('test#add');
$r->get('/get')->to('test#get');

subtest 'Add history' => sub {
    $t->get_ok('/')    # cookie準備
      ->get_ok('/hoge')->json_is( ["/hoge"] );

    # reload page
    $t->get_ok('/fuga')->get_ok('/fuga')->json_is( [ "/fuga", "/hoge" ] );
    $t->get_ok('/fuga?id=1')->get_ok('/fuga?id=1')->json_is( [ "/fuga?id=1", "/fuga", "/hoge" ] );

    # query
    $t->get_ok('/fuga?id=2')->json_is( [ "/fuga?id=2", "/fuga?id=1", "/fuga", "/hoge" ] );

    # 訪問済み
    $t->get_ok('/hoge')->json_is( [ "/hoge", "/fuga?id=2", "/fuga?id=1", "/fuga" ] );

};

subtest 'Get history' => sub {
    $t->get_ok('/get')->json_is( [ "/hoge", "/fuga?id=2", "/fuga?id=1", "/fuga" ] );
};

done_testing();

package Markets::Controller::Test;
use Mojo::Base 'Markets::Controller::Catalog';

sub get {
    my $c = shift;

    my $history = $c->model('service-customer')->get_history($c);
    return $c->render( json => $history );
}

sub add {
    my $c = shift;

    $c->model('service-customer')->add_history($c);
    my $history = $c->db_session->data('history');
    return $c->render( json => $history );
}
