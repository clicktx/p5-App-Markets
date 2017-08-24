package Markets::Schema::Base::ResultSet;
# use Mojo::Base 'DBIx::Class::ResultSet';
use Mojo::Base 'DBIx::Class::ResultSet::HashRef';

# Base::Result::insertで対応しているので不要
# sub create {
#     my $self = shift;
#
#     my $schema = $self->result_source->schema;
#     my $table  = $self->result_source;
#     my $now    = $schema->now;
#     $_[0]->{created_at} = $now if $table->has_column('created_at');
#     $_[0]->{updated_at} = $now if $table->has_column('updated_at');
#
#     $self->next::method(@_);
# }

sub update {
    my $self = shift;

    my $schema = $self->result_source->schema;
    if ( $self->result_source->has_column('updated_at') ) {
        $_[0]->{updated_at} = $schema->now;
    }

    $self->next::method(@_);
}

1;
__END__
=encoding utf8

=head1 NAME

Markets::Schema::Base::ResultSet

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Schema::Base::ResultSet> inherits all attributes from L<DBIx::Class::ResultSet> and implements
the following new ones.

=head1 METHODS

L<Markets::Schema::Base::ResultSet> inherits all methods from L<DBIx::Class::ResultSet::HashRef> and implements
the following new ones.

=head2 C<update>

Override method.

The difference, updating C<updated_at> on update.

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

L<DBIx::Class::ResultSet::HashRef>, L<DBIx::Class::ResultSet>, L<Markets::Schema>
