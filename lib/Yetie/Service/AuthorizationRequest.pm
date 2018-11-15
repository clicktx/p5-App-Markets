package Yetie::Service::AuthorizationRequest;
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

sub is_verify {
    my ( $self, $email, $token ) = @_;

    # NOTE: アクセス制限が必要？同一IP、時間内回数制限
    my $result = $self->resultset('AuthorizationRequest')->last_request($email);
    return $self->_logging('Not found') unless $result;

    # token
    return $self->_logging('Bad token') if $result->token ne $token;

    # activated
    return $self->_logging('Activated') if $result->is_activated;

    # expired
    my $expires = $self->factory('value-expires')->construct( value => $result->expires );
    return $self->_logging('Expired') if $expires->is_expired;

    # All passed
    return 1;
}

sub _logging {
    shift->app->log->info( 'Failed to authorization request: ' . shift );
    return 0;
}

1;
__END__

=head1 NAME

Yetie::Service::AuthorizationRequest

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Service::AuthorizationRequest> inherits all attributes from L<Yetie::Service> and implements
the following new ones.

=head1 METHODS

L<Yetie::Service::AuthorizationRequest> inherits all methods from L<Yetie::Service> and implements
the following new ones.

=head2 C<generate_token>

    my token = $service->generate_token($email);

Create one-time token and store it in the DB.

Return token string.

=head2 C<is_verify>

    my $bool = $service->is_verify( $email, $token );

Return boolean value.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Service>
