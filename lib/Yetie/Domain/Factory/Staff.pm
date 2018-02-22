package Yetie::Domain::Factory::Staff;
use Mojo::Base 'Yetie::Domain::Factory';

sub cook {
    my $self = shift;

    # account
    my $account = $self->factory('entity-account')->create( $self->{account} || {} );
    $self->param( account => $account );
}

1;
__END__

=head1 NAME

Yetie::Domain::Factory::Staff

=head1 SYNOPSIS

    my $entity = Yetie::Domain::Factory::Staff->new( %args )->create;

    # In controller
    my $entity = $c->factory('entity-staff')->create(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Factory::Staff> inherits all attributes from L<Yetie::Domain::Factory> and implements
the following new ones.

=head1 METHODS

L<Yetie::Domain::Factory::Staff> inherits all methods from L<Yetie::Domain::Factory> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

 L<Yetie::Domain::Factory>
