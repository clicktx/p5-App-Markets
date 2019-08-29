package Yetie::Schema::ResultSet;
use Mojo::Base 'DBIx::Class::ResultSet::HashRef';

has app    => sub { shift->result_source->schema->app };
has schema => sub { shift->result_source->schema };

# Base::Result::insertで対応しているので不要
# sub create {
#     my $self = shift;
#
#     my $schema = $self->result_source->schema;
#     my $table  = $self->result_source;
#     my $now    = $self->app->date_time->now;
#     $_[0]->{created_at} = $now if $table->has_column('created_at');
#     $_[0]->{updated_at} = $now if $table->has_column('updated_at');
#
#     $self->next::method(@_);
# }

# Mojo::Collection::each() like
sub each {
    my ( $self, $cb ) = @_;

    my @array = $self->all;
    return @array unless $cb;

    my $i = 1;
    $_->$cb( $i++ ) for @array;
    return $self;
}

sub last_id {
    my $self = shift;
    my $cond = shift || {};

    my $result = $self->search( $cond, { order_by => 'id DESC' } )->slice( 0, 0 )->first;
    return defined $result ? $result->id : undef;
}

sub limit {
    my $self = shift;

    my ( $offset, $limit ) = @_ > 1 ? ( shift, shift ) : ( 0, shift );
    my $last = $offset + $limit - 1;
    $self->slice( $offset, $last );
}

sub to_array {
    my $self    = shift;
    my @columns = $self->result_class->choose_column_name(@_);

    my @array;
    while ( my $row = $self->next ) {
        my %data = map { $_ => $row->$_ } @columns;
        push @array, \%data;
    }
    $self->reset;

    return wantarray ? @array : \@array;
}

sub to_data {
    my ( $self, $args ) = ( shift, shift // {} );
    my @data;
    $self->each( sub { push @data, $_->to_data($args) } );
    return \@data;
}

sub update {
    my $self = shift;

    $_[0]->{updated_at} = $self->app->date_time->now if $self->result_source->has_column('updated_at');
    $self->next::method(@_);
}

1;
__END__
=encoding utf8

=head1 NAME

Yetie::Schema::ResultSet

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Schema::ResultSet> inherits all attributes from L<DBIx::Class::ResultSet> and implements
the following new ones.

=head2 C<app>

    my $app = $rs->app;

    # Longer version
    my $app = $rs->result_source->schema->app;

=head2 C<schema>

    my $schema = $rs->schema;

    # Longer version
    my $schema = $rs->result_source->schema;

=head1 METHODS

L<Yetie::Schema::ResultSet> inherits all methods from L<DBIx::Class::ResultSet::HashRef> and implements
the following new ones.

=head2 C<each>

    my @elements = $rs->each;
    $rs->each( sub{ ... } );

    $rs->each( sub { say $_->column_name } );
    $rs->each( sub { my ( $res, $num ) = @_; ... } );

=head2 C<last_id>

    my $last_id = $rs->last_id;

    my $last_id = $rs->last_id( { foo => 'bar' } );

Return last id of undef.

=head2 C<limit>

MySQL like limit and offset.

    # select one row
    my $resultset = $rs->search( {} )->limit(1);

    # offset 5, and limit 10
    my $resultset = $rs->search( {} )->limit( 5, 10 );

Return L<DBIx::Class::ResultSet> object.

=head2 C<to_array>

    my $array_ref = $rs->seach({})->to_array(%options || \%options);
    my @array = $rs->seach({})->to_array(%options || \%options);

Return C<Array> or C<Array refference>.

Dump columns data.

=head2 C<to_data>

    my $data = $rs->search(...)->to_data(\%option);

Return C<Array refference>.

=over

=item OPTIONS

    my @data = $rs->search({})->to_array( columns => [qw/id name title/] );
    my @data = $rs->search({})->to_array( ignore_columns => [qw/id/] );

=back

=head2 C<update>

Override method.

The difference, updating C<updated_at> on update.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<DBIx::Class::ResultSet::HashRef>, L<DBIx::Class::ResultSet>, L<Yetie::Schema>
