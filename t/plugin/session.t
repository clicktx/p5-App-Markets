use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t   = Test::Mojo->new('App');
my $app = $t->app;

# use Mojo::Cookie::Response;
my $cookie = Mojo::Cookie::Request->new( name => 'sid', value => 'bar', path => '/' );
my $tx = Mojo::Transaction::HTTP->new();
$tx->req->cookies($cookie);
my $rs = $t->app->db->resultset('sessions');

my $session = Markets::Session->new(
    tx            => $tx,
    store         => Markets::Plugin::Session::Store::Teng->new( resultset => $rs ),
    transport     => MojoX::Session::Transport::Cookie->new,
    expires_delta => 3600,
);

# create session
my $sid = $session->create;
$session->flush;
ok $sid, 'created session';

# load session
$cookie = Mojo::Cookie::Request->new( name => 'sid', value => $sid, path => '/' );
$tx = Mojo::Transaction::HTTP->new();
$session->tx($tx);
$tx->req->cookies($cookie);
is $session->load, $sid, 'loading session';

# set data
$session->data( counter => 1 );
$session->flush;
$session->load;
is $session->data('counter'), 1, 'right session value';

# set cart data
$session->data( cart => 1 );
$session->flush;
$session->load;
is $session->data('cart'), 1, 'right cart value';
is_deeply $session->data, { counter => 1, cart => 1 }, 'right cart value';

# regenerate session
my $data    = $session->data;
my $new_sid = $session->regenerate_session;
$session->flush;
$session->load;
my $new_data = $session->data;
isnt $sid, $new_sid, 'created new sid';
is %$data, %$new_data, 'right session data';

# remove session
$session->expire;
$session->flush;
is $session->load, undef, 'removed session';

done_testing();
