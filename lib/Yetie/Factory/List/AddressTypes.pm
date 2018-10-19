package Yetie::Factory::List::AddressTypes;
use Mojo::Base 'Yetie::Factory';

sub cook {
    my $self = shift;

    $self->aggregate_collection( list => 'value-address_type', $self->param('list') || [] );
}

1;
__END__

=head1 NAME

Yetie::Factory::List::AddressTypes

=head1 SYNOPSIS

    my $entity = Yetie::Factory::List::AddressTypes->new( %args )->construct();

    # In controller
    my $entity = $c->factory('list-address_types')->construct(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Factory::List::AddressTypes> inherits all attributes from L<Yetie::Factory> and implements
the following new ones.

=head1 METHODS

L<Yetie::Factory::List::AddressTypes> inherits all methods from L<Yetie::Factory> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

 L<Yetie::Factory>
