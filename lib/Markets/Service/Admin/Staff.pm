package Markets::Service::Admin::Staff;
use Mojo::Base 'Markets::Service';
use Carp qw/croak/;

sub login {
    my ( $self, $staff_id ) = @_;
    return unless $staff_id;

    my $session = $self->controller->server_session;

    # 2重ログイン
    return if $session->staff_id;

    # Set staff id (logedin flag)
    $session->staff_id($staff_id);

    # Regenerate sid
    $session->regenerate_sid;
}

1;
__END__

=head1 NAME

Markets::Service::Admin::Staff

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Service::Admin::Staff> inherits all attributes from L<Markets::Service> and implements
the following new ones.

=head1 METHODS

L<Markets::Service::Admin::Staff> inherits all methods from L<Markets::Service> and implements
the following new ones.

=head2 C<login>

    $c->service('admin-staff')->login($staff_id);

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

L<Markets::Service>
