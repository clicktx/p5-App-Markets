package t::Util;

use strict;
use File::Spec;
use File::Basename qw(dirname);
use lib File::Spec->catdir( dirname(__FILE__), '..', 'lib' );
use lib 't/App/lib';
use Markets::Util;

BEGIN {
    # Check app mode
    unless ( $ENV{MOJO_MODE} ) {
        $ENV{MOJO_MODE} = 'test';
    }
    if ( $ENV{MOJO_MODE} eq 'production' ) {
        die "Do not run a test script on deployment environment";
    }
}

sub load_config {
    my $config_base_dir =
      File::Spec->rel2abs(
        File::Spec->catdir( dirname(__FILE__), 'App', 'config' ) );
    my $config_file = File::Spec->catfile( $config_base_dir, "test.conf" );
    my $conf = do $config_file;
    unless ( ref($conf) eq 'HASH' ) {
        die "test.conf does not retun HashRef.";
    }
    return $conf;
}

sub init_addon {
    my ( $self, $app, $name, $arg ) = ( shift, shift, shift, shift // {} );

    my $installed_addons = $app->addons->{installed};
    my $is_enabled   = $arg->{is_enabled} || 0;

    $installed_addons->{$name} = {
        is_enabled => $is_enabled,
        hooks      => [],
    };
    $app->addons->init($installed_addons);
}

1;
