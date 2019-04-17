package Yetie::Service::Authentication;
use Mojo::Base 'Yetie::Service';

sub create_token {
    my ( $self, $email, $settings ) = ( shift, shift, shift || {} );
    my $remote_address = $self->controller->remote_address;

    my $auth = $self->factory('entity-auth')->construct(
        email          => $email,
        action         => $settings->{action},
        continue_url   => $settings->{continue_url},
        remote_address => $remote_address,
        expires        => $settings->{expires},
    );

    # Store to DB
    $self->resultset('AuthenticationRequest')->store_token($auth);
    return $auth->token;
}

sub find_request {
    my ( $self, $token ) = @_;

    my $rs = $self->resultset('AuthenticationRequest');
    my $result = $rs->find( { token => $token }, { prefetch => 'email' } ) || return $self->_logging('Not found token');
    return $self->factory('entity-auth')->construct( $result->to_data );
}

# NOTE: アクセス制限が必要？同一IP、時間内回数制限
# email sha1を引数にして判定を追加する？
sub verify {
    my ( $self, $token ) = @_;

    my $auth = $self->find_request($token);
    return $self->factory('entity-auth')->construct() unless $auth;

    # last request
    my $last_result = $self->resultset('AuthenticationRequest')->find_last_by_email( $auth->email->value );

    # verify token
    $auth->verify_token( $last_result->token );
    return ( $self->_logging( $auth->error_message ), $auth )
      unless $auth->is_verified;

    # passed
    $last_result->update( { is_activated => 1 } );
    $auth->is_activated(1);
    return $auth;
}

sub _logging { shift->logging_warn( 'passwordless.authorization.failed', reason => shift ) && 0 }

1;
__END__

=head1 NAME

Yetie::Service::Authentication

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Service::Authentication> inherits all attributes from L<Yetie::Service> and implements
the following new ones.

=head1 METHODS

L<Yetie::Service::Authentication> inherits all methods from L<Yetie::Service> and implements
the following new ones.

=head2 C<create_token>

    my $token = $service->create_token( $email, \%options );

Create one-time token and store it in the DB.

Return token string.

B<OPTIONS>

=over 4

=item continue_url

Redirect url or route name.

=back

    my $token = $service->create_token( $email, { continue_url => 'RN_foo'} );

=head2 C<find_request>

    my $auth = $service->find_request($token);

Return L<Yetie::Domain::Entity::Authorization> object or C<undef>.

=head2 C<verify>

    my $auth = $service->verify($token);

Return Return L<Yetie::Domain::Entity::Authorization>.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Service>
