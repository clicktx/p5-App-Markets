package Yetie::Service::Authentication;
use Mojo::Base 'Yetie::Service';
use Carp qw(croak);

sub create_magic_link {
    my ( $self, $settings ) = ( shift, shift || {} );
    my $email_addr = delete $settings->{email};
    my $route = delete $settings->{route} || 'rn.auth.magic_link.verify';

    # action
    if ( !$settings->{action} ) {
        my $customer = $self->service('customer')->find_customer($email_addr);
        $settings->{action} = $customer->is_member ? 'login' : 'signup';
    }

    my $token = $self->create_token( $email_addr, $settings );
    return $self->controller->url_for( $route, token => $token->value );
}

sub create_token {
    my ( $self, $email_addr, $settings ) = ( shift, shift, shift || {} );
    my $remote_address = $self->controller->remote_address;

    my $action = $settings->{action};
    croak 'Not set action value' if !$action;

    my $auth = $self->factory('entity-auth')->construct(
        email          => $email_addr,
        action         => $action,
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

sub remember_token {
    my ( $self, $email_addr ) = @_;
    my $c = $self->controller;

    # Getter
    return $c->cookie('remember_token') if !$email_addr;

    # Setter
    my $expires  = time + $c->pref('cookie_expires_long');
    my $settings = {
        action  => 'login',
        expires => $expires,
    };
    my $token = $self->create_token( $email_addr, $settings );

    # Set cookies.
    $c->cookie( remember_token => $token->value, { expires => $expires, path => $self->_path_to_remember_me } );
    $c->cookie( has_remember_token => 1, { expires => $expires } );
    return $token;
}

sub remove_remember_token {
    my $self = shift;
    my $c    = $self->controller;

    # Remove cookies
    $c->cookie( remember_token => q{}, { expires => 0, path => $self->_path_to_remember_me } );
    $c->cookie( has_remember_token => q{}, { expires => 0 } );

    my $token = $self->remember_token;
    return if !$token;

    $c->resultset('AuthenticationRequest')->remove_request_by_token($token);
    return;
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

sub _path_to_remember_me {
    return shift->controller->url_for('RN_customer_auth_remember_me')->to_string;
}

sub _logging {
    return shift->logging_warn( 'passwordless.authentication.failed', reason => shift ) && 0;
}

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
        route           => 'RN_foo_bar',    # optional: default "rn.auth.magic_link.verify"
        action          => 'login',         # optional:
        continue_url    => 'RN_home',       # optional:
        expires         => 111222333444,    # optional:
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

expiration UNIX time.

=back

=head2 C<find_request>

    my $auth = $service->find_request($token);

Return L<Yetie::Domain::Entity::Authorization> object or C<undef>.

=head2 C<remember_token>

    # Setter
    $service->remember_token('foo@bar.baz');

    # Getter
    my $token = $service->remember_token;

Set/Get cookie "remember_token".

Setter method create auto log-in token.

=head2 C<remove_remember_token>

    $service->remove_remember_token;

Remove "remember_token" cookie and disable the auto log-in token.

=head2 C<verify>

    my $auth = $service->verify($token);

Return Return L<Yetie::Domain::Entity::Authorization>.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Service>
