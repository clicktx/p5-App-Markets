package Markets::Service::Admin::Staff;
use Mojo::Base 'Markets::Service';

sub login {
    my ( $self, $staff_id ) = @_;
    return unless $staff_id;

    my $session = $self->controller->server_session;

    # Set staff id
    $session->staff_id($staff_id);

    # Regenerate sid
    my $sid = $session->regenerate_sid;
    say "  .. regenerate_sid: " . $sid;    #debug
    return $sid;
}

sub logout {
    my $self = shift;

    my $session = $self->controller->server_session;
    return $self->model('account')->remove_session($session);
}

1;
__END__

=head1 NAME

Markets::Model::Service::Admin::Staff - Application Service Layer

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Service::Admin::Staff> inherits all attributes from L<Markets::Service> and implements
the following new ones.

=head1 METHODS

=head2 C<login>

    $c->service('admin-staff')->login($staff_id);

=head2 C<logout>

    $c->service('admin-staff')->logout;

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

L<Markets::Service>
