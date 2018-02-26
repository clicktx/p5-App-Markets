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

Yetie::Service::Staff

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Service::Staff> inherits all attributes from L<Yetie::Service> and implements
the following new ones.

=head1 METHODS

L<Yetie::Service::Staff> inherits all methods from L<Yetie::Service> and implements
the following new ones.

=head2 C<login>

    $c->service('staff')->login($staff_id);

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Service>
