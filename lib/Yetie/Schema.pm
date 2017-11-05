package Yetie::Schema;
use Mojo::Base 'DBIx::Class::Schema';
use Carp qw/croak/;
use DateTime;
use Mojo::Util 'camelize';
use Data::Page::Navigation;

our $VERSION   = 0.001;
our $TIME_ZONE = 'UTC';

has 'app';

__PACKAGE__->load_namespaces( default_resultset_class => 'Base::ResultSet' );

sub connect {
    my ( $self, $dsn, $user, $password ) = @_;

    my $dbi_attributes = {
        mysql_enable_utf8mb4 => 1,
        Callbacks            => {
            connected => sub {
                shift->do('SET NAMES utf8mb4');
                return;
            },
        },
    };
    my $extra_attributes = {};
    my @connect_info = ( $dsn, $user, $password, $dbi_attributes, $extra_attributes );

    return $self->SUPER::connect(@connect_info);
}

sub now { DateTime->now( time_zone => shift->TZ ) }

# This code is DBIx::Class::Schema::resultset
sub resultset {
    my ( $self, $source_name ) = @_;
    $self->throw_exception('resultset() expects a source name')
      unless defined $source_name;

    # Yetie uses a snake case.
    $source_name = camelize($source_name);
    return $self->source($source_name)->resultset;
}

sub sequence {
    my ( $self, $name ) = ( shift, camelize(shift) );
    warn '!!DEPRECATED method';

    my $rs = $self->resultset( $name . '::Sequence' );
    $rs->search->update( { id => \'LAST_INSERT_ID(id + 1)' } );
    $self->storage->last_insert_id;
}

sub time_zone { shift; return @_ ? $TIME_ZONE = shift : $TIME_ZONE }

sub today { shift->now->truncate( to => 'day' ) }

sub txn_failed {
    my ( $self, $err ) = @_;

    if ( $err =~ /Rollback failed/ ) {

        # ロールバックに失敗した場合
        $self->app->db_log->fatal($err);
        $self->app->error_log->fatal($err);
        croak $err;
    }
    else {
        # 何らかのエラーによりロールバックした
        $self->app->db_log->fatal($err);
        $self->app->error_log->fatal($err);
        croak $err;
    }
}

sub TZ { DateTime::TimeZone->new( name => shift->time_zone ) }

1;
__END__
=encoding utf8

=head1 NAME

Yetie::Schema

=head1 SYNOPSIS

    # Change time zone
    use Yetie::Schema;
    $Yetie::Schema::TIME_ZONE = 'Asia/Tokyo';

=head1 DESCRIPTION

=head1 METHODS

L<Yetie::Schema> inherits all methods from L<DBIx::Class::Schema>.

=head2 C<connect>

    my $schema = Yetie::Schema->connect( $dsn, $user, $password );

Set true L<DBI:mysql> option C<mysql_enable_utf8mb4> and do C<SET NAMES utf8mb4>.

=head2 C<now>

Return L<DateTime> object.

=head2 C<resultset>

    $schema->resultset($source_name);

    # Snake case can also be used!
    $schema->resultset('foo');      # Yetie::Schema::ResultSet::Foo
    $schema->resultset('bar-buz');  # Yetie::Schema::ResultSet::Bar::Buz

This method is alias for L<DBIx::Class::Schema/resultset>.
But you can use the snake case for C<$source_name>.

=head2 C<time_zone>

    # Getter
    my $time_zone = $schema->time_zone;

    # Setter
    $schema->time_zone($time_zone);

Get/Set time zone.
Default time zone C<UTC>

=head2 C<today>

Return L<DateTime> object.

=head2 C<txn_failed>

    use Try::Tiny;
    ...
    try {
        $schema->txn_do($cb);
    } catch {
        $schema->txn_failed($_);
    };
    ...

Logging transaction error.

=head2 C<TZ>

    my $tz = $schema->TZ;

Return L<DateTime::TimeZone> object.
Using time zone L</time_zone>.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Schema::Base::Result>, L<Yetie::Schema::Base::ResultSet>, L<DBIx::Class::Schema>
