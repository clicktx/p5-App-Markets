package Markets::Schema::Base::Result;
use Mojo::Base 'DBIx::Class::Core';

__PACKAGE__->load_components(qw/InflateColumn::DateTime AsFdat/);

sub insert {
    my $self = shift;

    my $schema = $self->result_source->schema;
    my $now    = $schema->now;
    $self->created_at($now) if $self->can('created_at');
    $self->updated_at($now) if $self->can('updated_at');

    $self->next::method(@_);
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

Markets::Schema::Base::Result

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Schema::Base::Result> inherits all attributes from L<DBIx::Class::Core> and implements
the following new ones.

=head1 METHODS

L<Markets::Schema::Base::Result> inherits all methods from L<DBIx::Class::Core> and implements
the following new ones.

=head2 C<insert>

Override method.

The difference, insert C<created_at> and C<updated_at> on insert(create).

=head2 C<update>

Override method.

The difference, updating C<updated_at> on update.

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

L<DBIx::Class::ResultSource>, L<DBIx::Class::Core>, L<Markets::Schema>
