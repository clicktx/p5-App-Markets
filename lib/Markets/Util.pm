package Markets::Util;
use Mojo::Base -strict;

use Exporter 'import';
use File::Find::Rule;
our @EXPORT_OK = ( qw(directories ), );

sub directories {
    my ( $dir, $option ) = ( shift, shift // {} );
    my @subdirs;
    my $rule = File::Find::Rule->new->name( $option->{ignore} );
    @subdirs =
      File::Find::Rule->directory->maxdepth(1)->not($rule)->in($dir);
    shift @subdirs;
    return \@subdirs;
}

1;
