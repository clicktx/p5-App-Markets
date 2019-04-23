package Yetie::Service::Email;
use Mojo::Base 'Yetie::Service';

sub find_email {
    my ( $self, $email_addr ) = @_;

    my $result = $self->resultset('Email')->find( { address => $email_addr } );
    my $data = $result ? $result->to_data : { value => $email_addr };
    return $self->factory('value-email')->construct($data);
}

sub to_verified {
    my ( $self, $email ) = @_;
    return if $email->is_verified;

    $self->resultset('email')->verified( $email->value );
    return $self->find_email( $email->value );
}

1;
__END__

=head1 NAME

Yetie::Service::Email

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Service::Email> inherits all attributes from L<Yetie::Service> and implements
the following new ones.

=head1 METHODS

L<Yetie::Service::Email> inherits all methods from L<Yetie::Service> and implements
the following new ones.

=head2 C<find_email>

    my $domain_value = $service->find_email('foo@bar.baz');

Return L<Yetie::Domain::Value::Email> object.

=head2 C<to_verified>

    $service->to_verified($value_email_obj);

Change the status of the email address to verified.

Return L<Yetie::Domain::Value::Email> object.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Service>
