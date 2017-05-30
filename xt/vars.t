use strict;
use warnings;
use Test::Vars;

all_vars_ok();

__END__

=head1 SYNOPSIS

    # make MANIFEST file
    perl -MExtUtils::Manifest -e 'ExtUtils::Manifest::mkmanifest()'

    # do test!
    prove -v t/vars.t
