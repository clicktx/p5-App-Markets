package Markets::Install::Util;
use Mojo::Base -strict;

use Exporter 'import';
use Mojolicious;
use Mojo::Home;
use Mojo::File 'path';
use Mojo::Util 'decode';

our @EXPORT_OK = (qw(insert_data));

my $MOJO_HOME = Mojo::Home->new->detect('Markets');
my $MOJO_MODE = Mojolicious->new->mode;

=head1 FUNCTIONS

L<Markets::Install::Util> implements the following functions, which can be imported individually.

=over

=item C<insert_data>

    insert_data( $schema, $data_file_path );

Insert data to database from file.


B<data file>

Data file charset is UTF-8 only.

    eg.
    {
        'SchemaName1' => {
            { column1 => 'foo' },
            { column1 => 'bar' },
            { column1 => 'buz' },
            ...
        },
        'SchemaName2' => [
            [ 'column1', 'column2', 'column3' ],
            [ undef , 'foo', 'bar' ],
            [ 'buz', undef , undef ],
            ...
        ],
    }

hash ref

    $schema->create(...);

array ref

    $schema->populate(...);

bulk insert.

=back

=cut

sub insert_data {
    my $schema = shift;
    my $path   = shift;

    my $content = decode( 'UTF-8', path($path)->slurp );
    my $data = eval "$content";

    my @keys = keys %{$data};
    foreach my $schema_name (@keys) {
        my $action;
        $action = 'create'   if ref $data->{$schema_name} eq 'HASH';
        $action = 'populate' if ref $data->{$schema_name} eq 'ARRAY';
        $schema->resultset($schema_name)->$action( $data->{$schema_name} );
    }
}


=over

=item C<load_config>

    # default: development.conf
    my $config = load_config();

    # production or development or test
    my $config = load_config( mode => 'production' );

Load config file.

=back

=cut

sub load_config {
    my %arg              = @_;
    my $mode             = $arg{mode} || $MOJO_MODE;
    my $config_file_path = path( $MOJO_HOME, 'config', $mode . '.conf' );
    my $conf = do $config_file_path;
    die "development.conf does not retun HashRef" if ref($conf) ne 'HASH';
    return $conf;
}

1;
