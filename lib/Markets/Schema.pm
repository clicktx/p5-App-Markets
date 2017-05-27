package Markets::Schema;
use Mojo::Base 'DBIx::Class::Schema';
use DateTime;
use Mojo::Util 'camelize';

our $VERSION   = 0.001;
our $TIME_ZONE = 'UTC';

__PACKAGE__->load_namespaces( default_resultset_class => 'ResultSetCommon' );

sub time_zone { shift; return @_ ? $TIME_ZONE = shift : $TIME_ZONE }
sub TZ { DateTime::TimeZone->new( name => $TIME_ZONE ) }
sub now { DateTime->now( time_zone => shift->TZ ) }
sub today { shift->now->truncate( to => 'day' ) }

sub sequence {
    my ( $self, $name ) = ( shift, camelize(shift) );

    my $rs = $self->resultset( $name . '::Sequence' );
    $rs->search->update( { id => \'LAST_INSERT_ID(id + 1)' } );
    $self->storage->last_insert_id;
}

1;
