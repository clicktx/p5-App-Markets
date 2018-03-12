package Yetie::Domain::Factory::Category;
use Mojo::Base 'Yetie::Domain::Factory';

sub cook {
    my $self = shift;

    # Aggregate breadcrumbs
    my $breadcrumbs = $self->param('breadcrumbs');
    $self->aggregate_collection( breadcrumbs => 'entity-breadcrumb', $breadcrumbs || [] );
}

1;
__END__

=head1 NAME

Yetie::Domain::Factory::Category

=head1 SYNOPSIS

    my $entity = Yetie::Domain::Factory::Category->new( %args )->create;

    # In controller
    my $entity = $c->factory('entity-category')->create(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Factory::Category> inherits all attributes from L<Yetie::Domain::Factory> and implements
the following new ones.

=head1 METHODS

L<Yetie::Domain::Factory::Category> inherits all methods from L<Yetie::Domain::Factory> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

 L<Yetie::Domain::Factory>
