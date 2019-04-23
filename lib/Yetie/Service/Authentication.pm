package Yetie::Service::Authentication;
use Mojo::Base 'Yetie::Service';

sub create_magic_link {
    my ( $self, $settings ) = ( shift, shift || {} );
    my $email_addr = $settings->{email};

    # action
    if ( !$settings->{action} ) {
        my $customer = $self->service('customer')->find_customer($email_addr);
        $settings->{action} = $customer->is_member ? 'login' : 'signup';
    }

    my $token = $self->create_token( $email_addr, $settings );
    return $self->controller->url_for( 'rn.auth.magic_link.verify', token => $token->value );
}

sub create_token {
    my ( $self, $email_addr, $settings ) = ( shift, shift, shift || {} );
    my $remote_address = $self->controller->remote_address;

    my $auth = $self->factory('entity-auth')->construct(
        email          => $email_addr,
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
    return $self->factory('entity-auth')->construct() if !$auth;

    # last request
    my $last_result = $self->resultset('AuthenticationRequest')->find_last_by_email( $auth->email->value );

    # verify token
    $auth->verify_token( $last_result->token );
    return ( $self->_logging( $auth->error_message ), $auth ) if !$auth->is_verified;

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

=head2 C<create_magic_link>

    my %settings = (
        email           => 'foo@bar.baz',
        action          => 'login',
        continue_url    => 'RN_home',
        expires         => 111222333444,
    );
    my $url = $service->create_magic_link( \%settings );

Return L<Mojo::URL> object.

=head2 C<create_token>

    my $token = $service->create_token( $email_addr, \%options );

Create one-time token and store it in the DB.

Return L<Yetie::Domain::Value::Token> object.

B<OPTIONS>

=over 4

=item action

Action after click url.

=item continue_url

Redirect url or route name.

    my $token = $service->create_token( $email_addr, { continue_url => 'RN_foo'} );

=item expires

expiration unix time.

=back

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