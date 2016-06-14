package t::Util;

use strict;
use File::Spec;
use File::Basename qw(dirname);

BEGIN {
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
        File::Spec->catdir( dirname(__FILE__), '..', 'config' ) );
    my $config_file = File::Spec->catfile( $config_base_dir, "test.conf" );
    my $conf = do $config_file;
    unless ( ref($conf) eq 'HASH' ) {
        die "test.conf does not retun HashRef.";
    }
    return $conf;
}

1;
