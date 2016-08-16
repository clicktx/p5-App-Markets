package t::Util;

use strict;
use File::Spec;
use File::Basename qw(dirname);
use lib File::Spec->catdir( dirname(__FILE__), '..', 'lib' );
use Markets::Util;

BEGIN {
    # Check app mode
    unless ( $ENV{MOJO_MODE} ) {
        $ENV{MOJO_MODE} = 'test';
    }
    if ( $ENV{MOJO_MODE} eq 'production' ) {
        die "Do not run a test script on deployment environment";
    }

    # @INC for Addons
    my $base_dir = File::Spec->catdir( dirname(__FILE__), '..', 'addons' );
    my $addons = Markets::Util::directories('addons');
    foreach my $path (@$addons) {
        push @INC, File::Spec->catdir( $base_dir, $path, 'lib' );
    }
}

sub load_config {
    my $config_base_dir =
      File::Spec->rel2abs(
        File::Spec->catdir( dirname(__FILE__), '..', 'config' ) );
    my $config_file = File::Spec->catfile( $config_base_dir, "test.conf" );
    my $conf = do $config_file;
    unless ( ref($conf) eq 'HASH' ) {
        die "test.conf does not retun HashRef.";
    }
    return $conf;
}

1;
