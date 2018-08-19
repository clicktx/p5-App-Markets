package Yetie::Domain::Factory::Emails;
use Mojo::Base 'Yetie::Domain::Factory';

sub cook {
    my $self = shift;

    $self->aggregate_collection( email_list => 'value-email', $self->param('email_list') || [] );
}

1;
__END__

=head1 NAME

Yetie::Domain::Factory::Emails

=head1 SYNOPSIS

    my $entity = Yetie::Domain::Factory::Emails->new( %args )->create;

    # In controller
    my $entity = $c->factory('entity-emails')->create(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Factory::Emails> inherits all attributes from L<Yetie::Domain::Factory> and implements
the following new ones.

=head1 METHODS

L<Yetie::Domain::Factory::Emails> inherits all methods from L<Yetie::Domain::Factory> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

 L<Yetie::Domain::Factory>
