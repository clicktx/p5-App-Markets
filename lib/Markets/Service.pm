package Markets::Service;
use Mojo::Base -base;

use Scalar::Util ();

has [qw/app controller/];

sub model { shift->app->model(@_) }

sub schema { shift->app->schema(@_) }

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

=head2 C<app>

    my $app  = $service->app;
    $service = $service->app(Mojolicious->new);

A reference back to the application that dispatched to this service, usually
a L<Mojolicious> object.

=head2 C<controller>

    # Get controller
    my $c = $service->controller;

    # Set controller
    $service->controller($c);

A reference back to the application that dispatched to this service, usually
a L<Mojolicious::Controller> object.

=head1 METHODS

L<Markets::Service> inherits all methods from L<Mojo::Base> and implements
the following new ones.

=head2 C<model>

    $service->model('hoge')->mehod;

Alias $app->model().

=head2 C<schema>

    my $schema = $service->schema;
    $schema->resultset('Foo::Bar')->search(...);

Alias $app->schema().

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

 L<Mojo::Base> L<Mojolicious>
