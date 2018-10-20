package Yetie::Service::Staff;
use Mojo::Base 'Yetie::App::Core::Service';
use Carp qw/croak/;

sub find_staff {
    my ( $self, $login_id ) = @_;

    my $result = $self->resultset('Staff')->find_by_login_id($login_id);
    my $data = $result ? $result->to_data : {};

    return $self->factory('entity-staff')->construct($data);
}

# NOTE: scenario(story) class?
sub login_process {
    my ( $self, $login_id, $raw_password ) = @_;

    # Find account
    my $staff = $self->find_staff($login_id);
    return $self->_login_failed( 'admin.login.failed.not_found', login_id => $login_id ) unless $staff->is_staff;

    # Authentication
    return $self->_login_failed( 'admin.login.failed.password', login_id => $login_id )
      unless $staff->password->is_verify($raw_password);

    return $self->_logged_in($staff);
}

sub _logged_in {
    my ( $self, $staff ) = @_;
    my $session = $self->controller->server_session;

    # Double login
    return 1 if $session->staff_id;

    # Set staff id (logedin flag)
    $session->staff_id( $staff->id );

    # Regenerate sid
    $session->regenerate_sid;
    return 1;
}

sub _login_failed {
    my $self = shift;
    $self->controller->stash( status => 401 );

    # Logging
    $self->logging_warn(@_);
    return 0;
}

1;
__END__

=head1 NAME

Yetie::Service::Staff

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Service::Staff> inherits all attributes from L<Yetie::App::Core::Service> and implements
the following new ones.

=head1 METHODS

L<Yetie::Service::Staff> inherits all methods from L<Yetie::App::Core::Service> and implements
the following new ones.

=head2 C<find_staff>

    my $entity = $service->find_staff($login_id);

Return L<Yetie::Domain::Entity::Staff> object.

=head2 C<login_process>

    my $bool = $service->login_process( $login_id, $raw_password );

Return boolean value.
Returns true if log-in succeeded.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::App::Core::Service>
