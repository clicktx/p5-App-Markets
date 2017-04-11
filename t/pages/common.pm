package t::pages::common;

use Mojo::Base 'Test::Class';
use t::Util;
use Test::More;
use Test::Mojo;

has [qw/t app ua tx csrf_token/];

sub setup : Test(setup) {
    my $self = shift;

    my $t = Test::Mojo->new('App');
    $self->{t}   = $t;
    $self->{app} = $t->app;
    $self->{ua} = $t->ua;
    $self->{tx} = $t->tx;

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
