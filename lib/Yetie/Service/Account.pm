package Yetie::Service::Account;
use Mojo::Base 'Yetie::Service';
use Yetie::Util qw(uuid);

sub generate_token {
    my ( $self, $email ) = @_;

    # Token
    my $token = uuid();

    # Request IP
    # NOTE: 'X-Real-IP', 'X-Forwarded-For'はどうする？
    my $request_ip = $self->controller->tx->remote_address || 'unknown';

    # Expires
    my $expires = $self->factory('value-expires')->construct();

    # Store to DB
    $self->resultset('AuthorizationRequest')->create(
        {
            email      => $email,
            token      => $token,
            request_ip => $request_ip,
            expires    => $expires,
        }
    );
    return $token;
}

1;
__END__

=head1 NAME

Yetie::Service::Account

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Service::Account> inherits all attributes from L<Yetie::Service> and implements
the following new ones.

=head1 METHODS

L<Yetie::Service::Account> inherits all methods from L<Yetie::Service> and implements
the following new ones.

=head2 C<generate_token>

    my token = $servece->generate_token($email);

Create one-time token and store it in the DB.

Return token string.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Service>
