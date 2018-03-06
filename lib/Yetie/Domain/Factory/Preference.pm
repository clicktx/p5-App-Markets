package Yetie::Domain::Factory::Preference;
use Mojo::Base 'Yetie::Domain::Factory';

sub cook {
    my $self = shift;

    # Aggregate properties
    $self->aggregate_kvlist( properties => 'entity-preference-property', $self->param('properties') || [] );
}

1;
__END__

=head1 NAME

Yetie::Domain::Factory::Preference

=head1 SYNOPSIS

    my $entity = Yetie::Domain::Factory::Preference->new( %args )->create;

    # In controller
    my $entity = $c->factory('entity-preference')->create(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Factory::Preference> inherits all attributes from L<Yetie::Domain::Factory> and implements
the following new ones.

=head1 METHODS

L<Yetie::Domain::Factory::Preference> inherits all methods from L<Yetie::Domain::Factory> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

 L<Yetie::Domain::Factory>
