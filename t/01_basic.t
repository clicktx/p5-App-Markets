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
    my $themes = Markets::Util::directories( 'themes',
        { ignore => [ 'default', 'admin' ] } );
    is_deeply $themes, ['mytheme'], 'loading mytheme';

    my $addons = Markets::Util::directories('addons');
    is ref $addons, 'ARRAY', 'loading addons';
};

# use Mojo::Cookie::Response;
subtest 'session' => sub {
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

    # remove session
    $session->expire;
    $session->flush;
    is $session->load, undef, 'removed session';
};

done_testing();
