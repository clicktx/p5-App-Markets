package Yetie::Service;
use Mojo::Base -base;
use Scalar::Util ();
use Carp;

has [qw/app controller/];

sub AUTOLOAD {
    my $self = shift;

    my ( $package, $method ) = our $AUTOLOAD =~ /^(.+)::(.+)$/;
    Carp::croak "Undefined subroutine &${package}::$method called"
      unless Scalar::Util::blessed $self && $self->isa(__PACKAGE__);

    # Call helper with current controller
    Carp::croak qq{Can't locate object method "$method" via package "$package"}
      unless my $helper = $self->app->renderer->get_helper($method);
    return $self->controller->$helper(@_);
}
sub c { return shift->controller }

sub factory { return shift->app->factory(@_) }

sub pref { return shift->app->pref(@_) }

sub resultset { return shift->app->schema->resultset(@_) }

sub service { return shift->controller->service(@_) }

sub schema { return shift->app->schema(@_) }

sub new {
    my ( $class, $c ) = ( shift, shift );

    my $app = $c->app;
    my $self = $class->SUPER::new( app => $app, controller => $c, @_ );

    Scalar::Util::weaken $self->{controller};
    return $self;
}

1;
__END__

=head1 NAME

Yetie::Service - Application Service Layer

=head1 SYNOPSIS

    my $service = $c->service('foo');

    my $service = $c->service('foo', bar => 1, baz => 2);

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

=head2 C<c>

    my $controller = $service->c;

Get controller object.
Alias L</controller>.

=head2 C<factory>

    my $factory = $service->factory('entity-foo');

Alias $app->factory().

=head2 C<pref>

    my $pref = $service->pref('foo');
    $service->pref( foo => 'bar' );

    # Longer version
    my $pref = $service->app->pref('foo');
    $service->app->pref( foo => 'bar' );

=head2 C<resultset>

    my $result_set = $service->resultset('Foo::Bar');

    # Longer version
    my $result_set = $service->schema->resultset('Foo::Bar');

=head2 C<service>

    my $hoo_service = $service->service('foo');

Alias $controller->service().

=head2 C<schema>

    my $schema = $service->schema;
    $schema->resultset('Foo::Bar')->search(...);

Alias $app->schema().

=head1 AUTOLOAD

In addition to the L<"ATTRIBUTES"> and L<"METHODS"> above you can also call helpers on L<Yetie> objects.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Mojo::Base>, L<Mojolicious>
