package t::pages::common;

use Mojo::Base 'Test::Class';
use t::Util;
use Test::More;
use Test::Mojo;

has [qw/t app ua tx csrf_token/];
has sid => sub { t::Util::get_sid( shift->t ) };
has server_session => sub {
    my $self           = shift;
    my $server_session = t::Util::server_session( $self->t->app );
    $server_session->load( $self->sid );
    return $server_session;
};

sub admin_loged_in {
    my $self = shift;

    my $post_data = {
        staff_id   => 'xxx',
        password   => 'xxx',
        csrf_token => $self->csrf_token,
    };
    $self->t->ua->post( '/admin/login', form => $post_data );
}

sub startup : Test(startup) {
    my $self = shift;

    my $t = Test::Mojo->new('App');
    $self->{t}   = $t;
    $self->{app} = $t->app;
    $self->{ua}  = $t->ua;
    $self->{tx}  = $t->tx;

    $t->ua->get('/');

    # CSRF token
    my $v = t::Util::get_cookie_values( $t => 'session' );
    $self->{csrf_token} = $v->{csrf_token};

    # redirect
    $self->ua->max_redirects(1);
}

sub basic : Tests() {
    my $self = shift;
    isa_ok $self->t, 'Test::Mojo', 'right isa Test::Mojo';
    ok $self->csrf_token, 'right csrf token';
}

1;
