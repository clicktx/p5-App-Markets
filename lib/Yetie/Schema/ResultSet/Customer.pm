package Yetie::Schema::ResultSet::Customer;
use Mojo::Base 'Yetie::Schema::Base::ResultSet';

has prefetch => sub { [ 'password', { emails => 'email' } ] };

sub find_by_email {
    my ( $self, $email ) = @_;

    my $customer_id = $self->get_id_by_email($email);
    return $self->find_by_id($customer_id);
}

sub find_by_id {
    my ( $self, $customer_id ) = @_;
    return $self->find( $customer_id, { prefetch => $self->prefetch } );
}

sub get_id_by_email {
    my ( $self, $email ) = @_;

    my $customer = $self->find( { 'email.address' => $email }, { prefetch => { emails => 'email' } } );
    return $customer ? $customer->id : undef;
}

sub search_by_email {
    my ( $self, $email ) = @_;

    my $customer_id = $self->get_id_by_email($email);
    return $self->search_by_id($customer_id);
}

sub search_by_id {
    my ( $self, $customer_id ) = @_;
    return $self->search( { 'me.id' => $customer_id }, { prefetch => $self->prefetch } );
}

1;
__END__
=encoding utf8

=head1 NAME

Yetie::Schema::ResultSet::Customer

=head1 SYNOPSIS

    my $data = $schema->resultset('Customer')->method();

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Schema::ResultSet::Customer> inherits all attributes from L<Yetie::Schema::Base::ResultSet> and implements
the following new ones.

=head1 METHODS

L<Yetie::Schema::ResultSet::Customer> inherits all methods from L<Yetie::Schema::Base::ResultSet> and implements
the following new ones.

=head2 C<find_by_email>

    my $customer = $resultset->find_by_email($email);

=head2 C<find_by_id>

    my $customer = $resultset->find_by_id($customer_id);

=head2 C<get_id_by_email>

    my $customer_id = $self->get_id_by_email($email);

=head2 C<search_by_email>

    my $ire = $resultset->search_by_email($email);

=head2 C<search_by_id>

    my itr = $resultset->search_by_id($customer_id);

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Schema::Base::ResultSet>, L<Yetie::Schema>
