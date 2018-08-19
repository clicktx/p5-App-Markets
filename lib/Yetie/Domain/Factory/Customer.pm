package Yetie::Domain::Factory::Customer;
use Mojo::Base 'Yetie::Domain::Factory';

sub cook {
    my $self = shift;

    # password
    $self->aggregate( password => 'value-password', $self->{password} || {} );

    # emails
    $self->aggregate( emails => 'entity-emails', { email_list => $self->param('emails') || [] } );
}

1;
__END__

=head1 NAME

Yetie::Domain::Factory::Customer

=head1 SYNOPSIS

    my $entity = Yetie::Domain::Factory::Customer->new( %args )->create;

    # In controller
    my $entity = $c->factory('entity-customer')->create(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Factory::Customer> inherits all attributes from L<Yetie::Domain::Factory> and implements
the following new ones.

=head1 METHODS

L<Yetie::Domain::Factory::Customer> inherits all methods from L<Yetie::Domain::Factory> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

 L<Yetie::Domain::Factory>
