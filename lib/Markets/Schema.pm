package Markets::Schema;
use Mojo::Base 'DBIx::Class::Schema';
use DateTime;
use Mojo::Util 'camelize';

our $VERSION   = 0.001;
our $TIME_ZONE = 'UTC';

__PACKAGE__->load_namespaces( default_resultset_class => 'Base::ResultSet' );

sub time_zone { shift; return @_ ? $TIME_ZONE = shift : $TIME_ZONE }
sub TZ { DateTime::TimeZone->new( name => $TIME_ZONE ) }
sub now { DateTime->now( time_zone => shift->TZ ) }
sub today { shift->now->truncate( to => 'day' ) }

# This code is DBIx::Class::Schema::resultset
sub resultset {
    my ( $self, $source_name ) = @_;
    $self->throw_exception('resultset() expects a source name')
      unless defined $source_name;

    # Markets uses a snake case.
    $source_name = camelize($source_name);
    return $self->source($source_name)->resultset;
}

sub sequence {
    my ( $self, $name ) = ( shift, camelize(shift) );

    my $rs = $self->resultset( $name . '::Sequence' );
    $rs->search->update( { id => \'LAST_INSERT_ID(id + 1)' } );
    $self->storage->last_insert_id;
}

1;
__END__
=encoding utf8

=head1 NAME

Markets::Schema

=head1 SYNOPSIS

    $schema->resultset('Addon')->any_method();

    # Snake case can also be used!
    $schema->resultset('addon')->any_method();

=head1 DESCRIPTION

=head1 METHODS

L<Markets::Schema> inherits all methods from L<DBIx::Class::Schema>.

=head2 C<resultset>

    $schema->resultset($source_name);

    # Snake case can also be used!
    $schema->resultset('foo');      # Markets::Schema::ResultSet::Foo
    $schema->resultset('bar-buz');  # Markets::Schema::ResultSet::Bar::Buz

This method is alias for L<DBIx::Class::Schema/resultset>.
But you can use the snake case for C<$source_name>.

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

L<Markets::Schema::Base::ResultSet>, L<Markets::Schema>
