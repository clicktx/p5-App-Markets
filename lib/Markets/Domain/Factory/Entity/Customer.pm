package Markets::Domain::Factory::Entity::Customer;
use Mojo::Base 'Markets::Domain::Factory';
use Markets::Domain::Collection qw/collection/;

sub cook {
    my $self = shift;

    # password
    my $password = $self->factory('entity-password')->create( $self->{password} || {} );
    $self->param( password => $password );

    # emails
    # my $emails = collection(qw/1 2 3/);
    # $self->param( emails => $emails );

    # billing_addresses
}

1;
__END__

=head1 NAME

Markets::Domain::Factory::Entity::Customer

=head1 SYNOPSIS

    my $entity = Markets::Domain::Factory::Entity::Customer->new( %args )->create;

    # In controller
    my $entity = $c->factory('entity-customer')->create(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Domain::Factory::Entity::Customer> inherits all attributes from L<Markets::Domain::Factory> and implements
the following new ones.

=head1 METHODS

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

 L<Markets::Domain::Factory>
