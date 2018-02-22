package Yetie::Domain::Factory::Account;
use Mojo::Base 'Yetie::Domain::Factory';

sub cook {
    my $self = shift;

    # password
    my $password = $self->factory('entity-password')->create( $self->{password} || {} );
    $self->param( password => $password );
}

1;
__END__

=head1 NAME

Yetie::Domain::Factory::Account

=head1 SYNOPSIS

    my $entity = Yetie::Domain::Factory::Account->new( %args )->create;

    # In controller
    my $entity = $c->factory('entity-account')->create(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Factory::Account> inherits all attributes from L<Yetie::Domain::Factory> and implements
the following new ones.

=head1 METHODS

L<Yetie::Domain::Factory::Account> inherits all methods from L<Yetie::Domain::Factory> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

 L<Yetie::Domain::Factory>
