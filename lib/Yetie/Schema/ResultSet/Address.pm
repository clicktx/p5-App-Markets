package Yetie::Schema::ResultSet::Address;
use Mojo::Base 'Yetie::Schema::ResultSet';

sub find_or_create_address {
    my ( $self, $data ) = @_;
    return $self->find_or_create( $data, { key => 'ui_hash' } );
}

1;
__END__
=encoding utf8

=head1 NAME

Yetie::Schema::ResultSet::Address

=head1 SYNOPSIS

    my $result = $schema->resultset('Address')->method();

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Schema::ResultSet::Address> inherits all attributes from L<Yetie::Schema::ResultSet> and implements
the following new ones.

=head1 METHODS

L<Yetie::Schema::ResultSet::Address> inherits all methods from L<Yetie::Schema::ResultSet> and implements
the following new ones.

=head2 C<find_or_create_address>

    my $result = $resultset->find_or_create_address(\%data);

Return L<Yetie::Schema::Result::Address> object.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Schema::ResultSet>, L<Yetie::Schema>
