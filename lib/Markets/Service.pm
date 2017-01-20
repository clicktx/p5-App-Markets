package Markets::Service;
use Mojo::Base -base;

use Scalar::Util ();

has [qw/app controller/];

sub new {
    my ( $self, $c ) = @_;
    my $app = $c->app;

    my $class = $self->SUPER::new( app => $app, controller => $c );

    Scalar::Util::weaken $class->{app};
    Scalar::Util::weaken $class->{controller};
    return $class;
}

1;
__END__

=head1 NAME

Markets::Service - Application Service Layer

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Service> inherits all attributes from L<Mojo::Base> and implements
the following new ones.

=head2 app

    my $app  = $service->app;
    $service = $service->app(Mojolicious->new);

A reference back to the application that dispatched to this service, usually
a L<Mojolicious> object.

=head2 controller

    my $c = $service->controller;

A reference back to the application that dispatched to this service, usually
a L<Mojolicious::Controller> object.

=head1 METHODS

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

 L<Mojo::Base> L<Mojolicious>
