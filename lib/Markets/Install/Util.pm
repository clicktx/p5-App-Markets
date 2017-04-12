package Markets::Install::Util;
use Mojo::Base -strict;

use Exporter 'import';
use Mojo::File 'path';
use Mojo::Util 'decode';

our @EXPORT_OK = (qw(insert_data));

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

1;
