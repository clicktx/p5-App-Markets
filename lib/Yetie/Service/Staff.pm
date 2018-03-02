package Yetie::Service::Staff;
use Mojo::Base 'Yetie::Service';
use Carp qw/croak/;

has resultset => sub { shift->schema->resultset('Staff') };

sub find_staff {
    my ( $self, $login_id ) = @_;

    my $result = $self->resultset->find_by_login_id($login_id);
    my $data = $result ? $result->to_data : {};

    return $self->factory('staff')->create($data);
}

# NOTE: scenario(story) class?
sub login_process {
    my ( $self, $login_id, $password ) = @_;

    my $staff = $self->find_staff($login_id);

    # FIXME: log messageをハードコーティングしない
    # Not found staff
    return $self->_login_failed( 'Login failed: not found account at login_id: ' . $login_id ) unless $staff->is_staff;

    # Failed password
    my $res = $staff->verify_password($password);
    return $self->_login_failed( 'Login failed: password mismatch at login id: ' . $login_id )
      unless $staff->logged_in;

    return $self->_logged_in($staff);
}

sub _logged_in {
    my ( $self, $staff ) = @_;
    my $session = $self->controller->server_session;

    # Double login
    return if $session->staff_id;

    # Set staff id (logedin flag)
    $session->staff_id( $staff->id );

    # Regenerate sid
    $session->regenerate_sid;
    return 1;
}

sub _login_failed {
    my ( $self, $message, $error_code ) = @_;
    $self->controller->stash( status => 401 );

    # Logging
    # my $message = $self->app->message($error_code);
    $self->app->admin_log->warn($message);
    return 0;
}

1;
__END__

=head1 NAME

Yetie::Service::Staff

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Service::Staff> inherits all attributes from L<Yetie::Service> and implements
the following new ones.

=head1 METHODS

L<Yetie::Service::Staff> inherits all methods from L<Yetie::Service> and implements
the following new ones.

=head2 C<find_staff>

    my $entity = $service->find_staff($login_id);

Return L<Yetie::Domain::Entity::Staff> object.

=head2 C<login_process>

    my $bool = $service->login_process( $login_id, $password );

Return boolean value.
Returns true if login succeeded.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Service>
