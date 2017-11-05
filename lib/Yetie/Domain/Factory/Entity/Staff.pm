package Yetie::Domain::Factory::Entity::Staff;
use Mojo::Base 'Yetie::Domain::Factory';

sub build {
    my ( $self, $arg ) = @_;

    # NOTE: staff のlogin_id は数字のみを許可しないこと
    my $where = $arg =~ /\D/ ? { 'me.login_id' => $arg } : { 'me.id' => $arg };
    my $columns = [
        qw(me.id me.login_id me.created_at me.updated_at),
        qw(password.id password.hash password.created_at password.updated_at),
    ];

    my $itr = $self->app->schema->resultset('Staff')->search(
        $where,
        {
            columns  => $columns,
            prefetch => 'password',
        }
    );
    my $data = $itr->hashref_first;
    return $data ? $self->create($data) : undef;
}

sub cook {
    my $self = shift;

    # password
    my $password = $self->factory('entity-password')->create( $self->{password} || {} );
    $self->param( password => $password );
}

1;
__END__

=head1 NAME

Yetie::Domain::Factory::Entity::Staff

=head1 SYNOPSIS

    my $entity = Yetie::Domain::Factory::Entity::Staff->new( %args )->create;

    # In controller
    my $entity = $c->factory('entity-staff')->create(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Factory::Entity::Staff> inherits all attributes from L<Yetie::Domain::Factory> and implements
the following new ones.

=head1 METHODS

L<Yetie::Domain::Factory::Entity::Staff> inherits all methods from L<Yetie::Domain::Factory> and implements
the following new ones.

=head2 C<build>

    my $entity = $factory->build( $id | $login_id );

Return L<Yetie::Domain::Entity::Staff> object.

Create entity by staff ID or login_id.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

 L<Yetie::Domain::Factory>
