package Markets::Service::Admin::Staff;
use Mojo::Base 'Markets::Service';
use Carp qw/croak/;

sub create_entity {
    my $self = shift;
    my $args = @_ > 1 ? +{@_} : shift;

    # NOTE: whereが空になるのを避けること
    croak "requied parameter 'staff_id' or 'login_id'" if !$args->{staff_id} and !$args->{login_id};

    my $where;
    $where = { 'me.id'       => $args->{staff_id} } if $args->{staff_id};
    $where = { 'me.login_id' => $args->{login_id} } if $args->{login_id};

    my $columns = [
        qw(me.id me.login_id me.created_at me.updated_at),
        qw(password.id password.hash password.created_at password.updated_at),
    ];
    my $rs = $self->app->schema->resultset('staff');
    my $data = $rs->search( $where, { columns => $columns, prefetch => 'password' } )->hashref_first;

    $self->app->factory('entity-staff')->create( $data || {} );
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

Markets::Service::Admin::Staff

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Service::Admin::Staff> inherits all attributes from L<Markets::Service> and implements
the following new ones.

=head1 METHODS

L<Markets::Service::Admin::Staff> inherits all methods from L<Markets::Service> and implements
the following new ones.

=head2 C<create_entity>

    my $staff = $c->service('admin-staff')->create_entity($staff_id);

    my $staff = $c->service('admin-staff')->create_entity($staff_login_id);

=head2 C<login>

    $c->service('admin-staff')->login($staff_id);

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

L<Markets::Service>
