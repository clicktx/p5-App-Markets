package Yetie::Service;
use Mojo::Base -base;
use Scalar::Util ();

has [qw/app controller/];

sub factory { shift->app->factory(@_) }

sub service { shift->controller->service(@_) }

sub schema { shift->app->schema(@_) }

sub new {
    my ( $class, $c ) = @_;

    my $app = $c->app;
    my $self = $class->SUPER::new( app => $app, controller => $c );

    Scalar::Util::weaken $self->{app};
    Scalar::Util::weaken $self->{controller};
    return $self;
}

1;
__END__

=head1 NAME

Yetie::Service - Application Service Layer

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

L<Yetie::Service> inherits all methods from L<Mojo::Base> and implements
the following new ones.

=head2 C<factory>

    my $factory = $service->factory('entity-foo');

Alias $app->factory().

=head2 C<service>

    my $hoo_service = $service->service('foo');

Alias $controller->service().

=head2 C<schema>

    my $schema = $service->schema;
    $schema->resultset('Foo::Bar')->search(...);

Alias $app->schema().

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Mojo::Base>, L<Mojolicious>
