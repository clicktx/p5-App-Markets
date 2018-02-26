package Yetie::Domain::Factory::Customer;
use Mojo::Base 'Yetie::Domain::Factory';

has resultset => sub { shift->app->schema->resultset('Customer') };

sub build {
    my ( $self, $arg ) = ( shift, shift // '' );
    my $itr = $arg =~ /\@/ ? $self->resultset->search_by_email($arg) : $self->resultset->search_by_id($arg);

    my $data = $itr->hashref_first || {};
    return $self->create($data);
}

sub cook {
    my $self = shift;

    # password
    $self->aggregate( password => 'entity-password', $self->{password} || {} );

    # emails
    # my $emails = collection(qw/1 2 3/);
    # $self->param( emails => $emails );

    # billing_addresses
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

=head2 C<build>

    my $entity = $factory->build( $id | $email );

Return L<Yetie::Domain::Entity::Customer> object.

Create entity by customer ID or Email address.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

 L<Yetie::Domain::Factory>
