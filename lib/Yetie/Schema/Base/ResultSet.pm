package Yetie::Schema::Base::ResultSet;
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

# Mojo::Collection::each() like
sub each {
    my ( $self, $cb ) = @_;

    my @array = $self->all;
    return @array unless $cb;

    my $i = 1;
    $_->$cb( $i++ ) for @array;
    return $self;
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

Yetie::Schema::Base::ResultSet

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Schema::Base::ResultSet> inherits all attributes from L<DBIx::Class::ResultSet> and implements
the following new ones.

=head1 METHODS

L<Yetie::Schema::Base::ResultSet> inherits all methods from L<DBIx::Class::ResultSet::HashRef> and implements
the following new ones.

=head2 C<each>

    my @elements = $rs->each;
    $rs->each( sub{ ... } );

    $rs->each( sub { say $_->column_name } );
    $rs->each( sub { my ( $res, $num ) = @_; ... } );

=head2 C<to_array>

    my $array_ref = $rs->seach({})->to_array(%options || \%options);
    my @array = $rs->seach({})->to_array(%options || \%options);

Return C<Array> or C<Array refference>.

Dump columns data.

    my @data = $rs->search({})->to_array( columns => [qw/id name title/] );
    my @data = $rs->search({})->to_array( ignore_columns => [qw/id/] );

=head2 C<update>

Override method.

The difference, updating C<updated_at> on update.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<DBIx::Class::ResultSet::HashRef>, L<DBIx::Class::ResultSet>, L<Yetie::Schema>
