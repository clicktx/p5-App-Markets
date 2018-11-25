package Yetie::Service::Authorization;
use Mojo::Base 'Yetie::Service';

sub generate_token {
    my ( $self, $email ) = @_;

    # Request IP
    # NOTE: 'X-Real-IP', 'X-Forwarded-For'はどうする？
    my $request_ip = $self->controller->tx->remote_address || 'unknown';

    my $authorization = $self->factory('entity-authorization')->construct(
        email      => $email,
        request_ip => $request_ip,
    );

    # Store to DB
    my $result = $self->resultset('AuthorizationRequest')->create(
        {
            email      => $email,
            token      => $authorization->token,
            request_ip => $request_ip,
            expires    => $authorization->expires,
        }
    );
    return $authorization->token;
}

# NOTE: アクセス制限が必要？同一IP、時間内回数制限
# email sha1を引数にして判定を追加する？
sub validate_token {
    my ( $self, $token ) = @_;

    my $rs = $self->resultset('AuthorizationRequest');

    my $request = $rs->find( { token => $token } );
    return $self->_logging('Not found') unless $request;

    # Is last request?
    my $email        = $request->email;
    my $last_request = $rs->find_last_by_email($email);
    return $self->_logging('Not last request') if $token ne $last_request->token;

    # activated
    return $self->_logging('Activated') if $request->is_activated;

    # expired
    my $expires = $self->factory('value-expires')->construct( value => $request->expires );
    return $self->_logging('Expired') if $expires->is_expired;

    # Token activated
    $request->update( { is_activated => 1 } );

    # All passed
    return 1;
}

sub validate {
    my ( $self, $token ) = @_;

    my $rs = $self->resultset('AuthorizationRequest');
    my $result = $rs->find( { token => $token } );
    return $self->_logging('Not found token') unless $result;

    # last request
    my $last_result = $rs->find_last_by_email( $result->email );
    return $self->_logging('Not found last request') unless $last_result;

    my $factory      = $self->factory('entity-authorization');
    my $passwordless = $factory->construct( $result->to_hash );

    # validate token
    return $self->logging( $passwordless->error_message ) unless $passwordless->is_validated( $last_result->token );

    # Token activated
    $result->update( { is_activated => 1 } );
    return $factory->construct( $result->to_hash );
}

sub _logging {
    shift->app->log->info( 'Failed to authorization request: ' . shift );
    return;
}

1;
__END__

=head1 NAME

Yetie::Service::Authorization

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Service::Authorization> inherits all attributes from L<Yetie::Service> and implements
the following new ones.

=head1 METHODS

L<Yetie::Service::Authorization> inherits all methods from L<Yetie::Service> and implements
the following new ones.

=head2 C<generate_token>

    my $token = $service->generate_token($email);

Create one-time token and store it in the DB.

Return token string.

=head2 C<validate_token>

    my $bool = $service->validate_token($token);

Return boolean value.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Service>
