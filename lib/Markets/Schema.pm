package Markets::Schema;
use Mojo::Base 'DBIx::Class::Schema';
use DateTime;

our $VERSION   = 0.001;
our $TIME_ZONE = 'America/Los_Angeles';

__PACKAGE__->load_namespaces();

sub time_zone { shift; return @_ ? $TIME_ZONE = shift : $TIME_ZONE }
sub TZ { DateTime::TimeZone->new( name => $TIME_ZONE ) }
sub now { DateTime->now( time_zone => shift->TZ ) }
sub today { shift->now->truncate( to => 'day' ) }

1;
