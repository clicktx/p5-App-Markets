package Markets::Schema::ResultSet::Customer;
use Mojo::Base 'Markets::Schema::Base::ResultSet';

sub find_by_email {
    my ( $self, $email ) = @_;

    my $customer = $self->find( { 'email.address' => $email }, { prefetch => { emails => 'email' } } );
    return $customer ? $self->find_by_id( $customer->id ) : undef;
}

sub find_by_id {
    my ( $self, $customer_id ) = @_;
    return $self->find( { 'me.id' => $customer_id }, { prefetch => [ 'password', { emails => 'email' } ] } );
}

1;
__END__
=encoding utf8

=head1 NAME

Markets::Schema::ResultSet::Customer

=head1 SYNOPSIS

    my $data = $schema->resultset('Customer')->method();

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Schema::ResultSet::Customer> inherits all attributes from L<Markets::Schema::Base::ResultSet> and implements
the following new ones.

=head1 METHODS

L<Markets::Schema::ResultSet::Customer> inherits all methods from L<Markets::Schema::Base::ResultSet> and implements
the following new ones.

=head2 C<find_by_email>

    my $customer = $rs->find_by_email($email);

=head2 C<find_by_id>

    my $customer = $rs->find_by_id($customer_id);

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

L<Markets::Schema::Base::ResultSet>, L<Markets::Schema>
