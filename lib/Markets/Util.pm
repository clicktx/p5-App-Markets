package Markets::Util;
use Mojo::Base -strict;

use Exporter 'import';
use File::Find::Rule;
our @EXPORT_OK = ( qw(directories ), );

=head1 FUNCTIONS

L<Markets::Util> implements the following functions, which can be imported
individually.

=over

=item C<directories>

List all sub directories in a directory.

B<options>

ignore - ignore directory name.

    use Markets::Util qw(directories);

    $sub_directories = directories('hoge', { ignore => ['huga'] });

=back

=cut

sub directories {
    my ( $dir, $options ) = ( shift, shift // {} );
    my @sub_directories;

    my $rule =
      File::Find::Rule->not( File::Find::Rule->name( $options->{ignore} ) )
      ->maxdepth(1)->directory->start($dir);
    while ( my $sub_dir = $rule->match ) {
        $sub_dir =~ s/$dir\/?//;
        push @sub_directories, $sub_dir if $sub_dir;
    }
    return \@sub_directories;
}

1;
