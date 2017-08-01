package Markets::Domain::Factory::Entity::Staff;
use Mojo::Base 'Markets::Domain::Factory';
use Markets::Domain::Collection qw/collection/;

sub cook {
    my $self = shift;

    # password
    my $password = $self->factory('entity-password')->create( $self->{password} || {} );
    $self->param( password => $password );

}

1;
__END__

=head1 NAME

Markets::Domain::Factory::Entity::Staff

=head1 SYNOPSIS

    my $entity = Markets::Domain::Factory::Entity::Staff->new( %args )->create;

    # In controller
    my $entity = $c->factory('entity-customer')->create(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Domain::Factory::Entity::Staff> inherits all attributes from L<Markets::Domain::Factory> and implements
the following new ones.

=head1 METHODS

L<Markets::Domain::Factory::Entity::Staff> inherits all methods from L<Markets::Domain::Factory> and implements
the following new ones.

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

 L<Markets::Domain::Factory>
