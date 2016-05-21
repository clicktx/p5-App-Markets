package Markets::Util;
use Mojo::Base -base;
use File::Find::Rule;

sub list_themes {
    my ( $self, $dir ) = ( shift, shift // '' );
    my $rule = File::Find::Rule->new->name(qw/default admin/);
    my @subdirs =
      File::Find::Rule->directory->maxdepth(1)->not($rule)->in($dir);
    shift @subdirs;
    return \@subdirs;
}

1;
