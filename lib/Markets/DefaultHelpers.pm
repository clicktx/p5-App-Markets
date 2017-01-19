package Markets::DefaultHelpers;
use Mojo::Base 'Mojolicious::Plugin';

use Carp qw/croak/;
use Mojo::Util qw/camelize/;
use Mojo::Loader ();

sub register {
    my ( $self, $app, $conf ) = @_;

    # Get constant value
    $app->helper(
        const => sub {
            my ( $c, $key ) = @_;
            my $constants = $c->stash('constants');
            unless ( $constants->{$key} ) {
                $c->app->log->warn("const('$key') has no constant value.");
                croak "const('$key') has no constant value.";
            }
            return $constants->{$key};
        }
    );

    # Set stash template
    $app->helper( template => sub { shift->stash( template => shift ) } );

    # Add service helper
    $app->helper( service => sub { _service(@_) } );
}

sub _service {
    my ( $c, $name ) = @_;
    $name = camelize($name) if $name =~ /^[a-z]/;
    Carp::croak 'Service name is empty.' unless $name;

    my $service;
    return $service if $service = $c->app->{service_class}{$name};

    # Load module
    my $class = camelize( $c->app->moniker ) . "::Service::" . $name;
    _load_class($class);

    $service = $class->new( controller => $c );
    Scalar::Util::weaken( $service->{controller} );

    return $service;
}

sub _load_class {
    my $class = shift;

    if ( my $e = Mojo::Loader::load_class($class) ) {
        die ref $e ? "Exception: $e" : "$class not found!";
    }
}

1;
__END__

=head1 NAME

Markets::DefaultHelpers - Default helpers plugin for Markets

=head1 DESCRIPTION

=head1 HELPERS

=head2 const

    my $hoge = $c->const('hoge');

Get constant value.

=head2 template

    $c->template('hoge/index');

Alias for $c->stash(template => 'hoge/index');

=head2 service

    # Your service
    package Markets::Service::Cart;

    sub calculate {
        my $self = shift;
        my $c = $self->controller;
        ...
    }

    # Your controller
    $c->service('cart')->calculate(...);
    $c->helpers->service('cart')->calculate(...);


Service Layer accessor.

=head1 AUTHOR

Markets authors.
