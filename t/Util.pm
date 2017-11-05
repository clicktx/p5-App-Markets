package t::Util;

use strict;
use File::Spec;
use File::Basename qw(dirname);
use lib File::Spec->catdir( dirname(__FILE__), '..', 'lib' );
use lib 't/App/lib', 't/lib';
use Yetie::Util;
use Mojo::Util qw(b64_decode);
use Mojo::JSON;

BEGIN {
    # Check app mode
    unless ( $ENV{MOJO_MODE} ) {
        $ENV{MOJO_MODE} = 'test';
    }
    if ( $ENV{MOJO_MODE} eq 'production' ) {
        die "Do not run a test script on deployment environment";
    }
}

sub get_cookie_values {
    my $t    = shift;
    my $name = shift;

    my ($cookie) = grep { $_->name eq $name } @{ $t->ua->cookie_jar->all };
    return unless $cookie;

    my $value = $cookie->value;
    $value =~ y/-/=/;
    return Mojo::JSON::j( b64_decode $value);
}

sub get_sid {
    my $t = shift;
    my ($cookie) = grep { $_->name eq 'sid' } @{ $t->ua->cookie_jar->all };
    return $cookie ? $cookie->value : undef;
}

sub init_addon {
    my ( $self, $app, $name, $arg ) = ( shift, shift, shift, shift // {} );

    my $installed_addons = $app->addons->installed;
    my $is_enabled = $arg->{is_enabled} || 0;

    $installed_addons->{$name} = {
        is_enabled => $is_enabled,
        triggers      => [],
    };
    $app->addons->init($installed_addons);

    # create table etc.
    _install_addon( $app, $installed_addons );
}

sub server_session {
    my $app = shift;

    # use Mojo::Cookie::Response;
    my $cookie = Mojo::Cookie::Request->new( name => 'sid', value => 'bar', path => '/' );
    my $tx = Mojo::Transaction::HTTP->new();
    $tx->req->cookies($cookie);

    return Yetie::Session::ServerSession->new(
        tx            => $tx,
        store         => Yetie::Session::Store::Dbic->new( schema => $app->schema ),
        transport     => MojoX::Session::Transport::Cookie->new,
        expires_delta => 3600,
    );
}

sub _install_addon {
    my ( $app, $addons ) = @_;
    foreach my $class_name ( keys %{$addons} ) {
        my $addon = $app->addons->addon($class_name);
        $addon->install;
    }
}

1;
