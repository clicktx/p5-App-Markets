use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t   = Test::Mojo->new('Markets::Web');
my $app = $t->app;

# use Mojo::Cookie::Response;
my $cookie =
  Mojo::Cookie::Request->new( name => 'sid', value => 'bar', path => '/' );
my $tx = Mojo::Transaction::HTTP->new();
$tx->req->cookies($cookie);
my $rs = $t->app->db->resultset('sessions');

my $session = MojoX::Session->new(
    tx            => $tx,
    store         => Markets::Session::Store::Teng->new( resultset => $rs ),
    transport     => MojoX::Session::Transport::Cookie->new,
    expires_delta => 3600,
);

# create session
my $sid = $session->create;
$session->flush;
ok $sid, 'created session';

# load session
$cookie =
  Mojo::Cookie::Request->new( name => 'sid', value => $sid, path => '/' );
$tx = Mojo::Transaction::HTTP->new();
$session->tx($tx);
$tx->req->cookies($cookie);
is $session->load, $sid, 'loading session';

# set data
$session->data( counter => 1 );
is $session->data('counter'), 1, 'right session value';

# set cart data
$session->data( cart => 1 );
is $session->data('cart'), 1, 'right cart value';

# remove session
$session->expire;
$session->flush;
is $session->load, undef, 'removed session';

done_testing();
