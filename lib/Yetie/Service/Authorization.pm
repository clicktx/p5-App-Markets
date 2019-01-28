package Yetie::Service::Authorization;
use Mojo::Base 'Yetie::Service';

sub generate_token {
    my ( $self, $email, $opt ) = ( shift, shift, shift || {} );

    my $request_ip    = $self->controller->request_ip_address;
    my $authorization = $self->factory('entity-authorization')->construct(
        email      => $email,
        redirect   => $opt->{redirect},
        request_ip => $request_ip,
        expires    => $opt->{expires},
    );

    # Store to DB
    $self->resultset('AuthorizationRequest')->store_token($authorization);
    return $authorization->token;
}

sub find {
    my ( $self, $token ) = @_;

    my $rs = $self->resultset('AuthorizationRequest');
    my $result = $rs->find( { token => $token } ) || return $self->_logging('Not found token');
    return $self->factory('entity-authorization')->construct( $result->to_hash );
}

# NOTE: アクセス制限が必要？同一IP、時間内回数制限
# email sha1を引数にして判定を追加する？
sub validate {
    my ( $self, $token ) = @_;

    my $authorization = $self->find($token);
    return $self->factory('entity-authorization')->construct() unless $authorization;

    # last request
    my $last_resultset = $self->resultset('AuthorizationRequest')->find_last_by_email( $authorization->email );

    # validate token
    $authorization->validate_token( $last_resultset->token );
    return ( $self->_logging( $authorization->error_message ), $authorization )
      unless $authorization->is_valid;

    # passed
    $last_resultset->activate;
    $authorization->is_activated(1);
    return $authorization;
}

sub _logging { shift->logging_warn( 'passwordless.authorization.failed', reason => shift ) && 0 }

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

    my $token = $service->generate_token( $email, \%options );

Create one-time token and store it in the DB.

Return token string.

B<OPTIONS>

=over 4

=item redirect

Redirect url or route name.

=back

    my $token = $service->generate_token( $email, { redirect => 'RN_foo'} );

=head2 C<find>

    my $authorization = $service->find($token);

Return L<Yetie::Domain::Entity::Authorization> object or C<undef>.

=head2 C<validate>

    my $authorization = $service->validate($token);

Return Return L<Yetie::Domain::Entity::Authorization>.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Service>
