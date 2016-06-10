package t::Util;
use strict;

BEGIN {
    unless ( $ENV{MOJO_MODE} ) {
        $ENV{MOJO_MODE} = 'test';
    }
    if ( $ENV{MOJO_MODE} eq 'production' ) {
        die "Do not run a test script on deployment environment";
    }
}

1;
