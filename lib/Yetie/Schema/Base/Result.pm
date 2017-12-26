package Yetie::Schema::Base::Result;
use Mojo::Base 'DBIx::Class::Core';

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

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

    my $schema = $self->result_source->schema;
    my $now    = $schema->now;
    $self->created_at($now) if $self->can('created_at');
    $self->updated_at($now) if $self->can('updated_at');

    $self->next::method(@_);
}

sub to_hash {
    my $self    = shift;
    my @columns = $self->result_class->choose_column_name(@_);

    my %pair;
    $pair{$_} = $self->get_column($_) for @columns;

    return wantarray ? (%pair) : \%pair;
}

sub update {
    my $self = shift;

    my $schema = $self->result_source->schema;
    if ( $self->can('updated_at') ) {
        $self->updated_at( $schema->now );
    }

    $self->next::method(@_);
}

1;
__END__
=encoding utf8

=head1 NAME

Yetie::Schema::Base::Result

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Schema::Base::Result> inherits all attributes from L<DBIx::Class::Core> and implements
the following new ones.

=head1 METHODS

L<Yetie::Schema::Base::Result> inherits all methods from L<DBIx::Class::Core> and implements
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

=head2 C<to_hash>

    my %data = $result->to_hash();
    my $data = $result->to_hash();

Return C<Hash> or C<Hash refference>.

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
