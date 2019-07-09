package Yetie::Schema::Result;
use Mojo::Base 'DBIx::Class::Core';

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

has schema => sub { shift->result_source->schema };

sub choose_column_name {
    my $self = shift;
    my $args = @_ ? @_ > 1 ? {@_} : { %{ $_[0] } } : {};

    my @columns        = $args->{columns}        ? @{ $args->{columns} }        : $self->columns;
    my @ignore_columns = $args->{ignore_columns} ? @{ $args->{ignore_columns} } : ();

    my %cnt;
    $cnt{$_}++ for ( @columns, @ignore_columns );
    my @uniq = grep { $cnt{$_} < 2 } keys %cnt;

    return wantarray ? @uniq : \@uniq;
}

sub insert {
    my $self = shift;

    my $now = Yetie::App::Core::DateTime->now;
    $self->created_at($now) if $self->can('created_at');

    $self->next::method(@_);
}

# NOTE: Arguments ($class, \%options)
sub to_data {
    my %pair = shift->get_inflated_columns;
    return \%pair;
}

sub to_hash {
    my $self    = shift;
    my @columns = $self->result_class->choose_column_name(@_);

    my %pair;
    $pair{$_} = $self->get_column($_) for @columns;

    return \%pair;
}

sub update {
    my $self = shift;

    $self->updated_at( Yetie::App::Core::DateTime->now ) if $self->can('updated_at');
    $self->next::method(@_);
}

1;
__END__
=encoding utf8

=head1 NAME

Yetie::Schema::Result

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Schema::Result> inherits all attributes from L<DBIx::Class::Core> and implements
the following new ones.

=head1 METHODS

L<Yetie::Schema::Result> inherits all methods from L<DBIx::Class::Core> and implements
the following new ones.

=head2 C<choose_column_name>

    # pick on columns
    my $cols = $result->choose_column_name( columns => [qw/id name title/] );
    my @cols = $result->choose_column_name( columns => [qw/id name title/] );

    # ignored columns
    my $cols = $result->choose_column_name( ignore_columns => [qw/id/] );
    my @cols = $result->choose_column_name( ignore_columns => [qw/id/] );

Return C<Array> or C<Array refference>.

=head2 C<insert>

Override method.

The difference, insert C<created_at> and C<updated_at> on insert(create).

=head2 C<to_data>

    my $hash = $result->to_data;

Return C<Hash refference> of column, object|value pairs.

NOTE: Values for any columns set to use inflation will be inflated and returns as objects.

See L<DBIx::Class::Row/get_inflated_columns>.

C<options>

Argumtnts from ResultSet::to_data(\%options)

    # In main
    my $data = $resultset->to_data( { foo => 'bar' } );

    # Override Result Class
    sub to_data {
        my $self    = shift;
        # { foo => 'bar' }
        my $options = shift;
        ...
    }

=head2 C<to_hash>

    my $hash = $result->to_hash();

    # Only columns "hoo" and "bar"
    my $hash = $result->to_hash( columns => [ 'hoo', 'bar' ] );

    # Ignore columns "hoo" and "bar"
    my $hash = $result->to_hash( ignore_columns => [ 'hoo', 'bar' ] );

Return C<Hash refference>.

=over

=item OPTIONS

    # pick on columns
    my %data = $restul->to_hash( columns => [qw/foo bar/] );

    # ignored columns
    my %data = $result->to_hash( ignore_columns => [qw/foo bar/] );

=back

=head2 C<update>

Override method.

The difference, updating C<updated_at> on update.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<DBIx::Class::ResultSource>, L<DBIx::Class::Core>, L<Yetie::Schema>
