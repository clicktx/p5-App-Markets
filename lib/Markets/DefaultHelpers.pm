package Markets::DefaultHelpers;
use Mojo::Base 'Mojolicious::Plugin';

use Carp qw/croak/;
use Scalar::Util ();
use Mojo::Util qw/camelize/;

sub register {
    my ( $self, $app, $conf ) = @_;

    # Alias helpers
    $app->helper( cookie_session => sub { shift->session(@_) } );
    $app->helper( template => sub { shift->stash( template => shift ) } );

    $app->helper( pref    => sub { _pref(@_) } );
    $app->helper( service => sub { _service(@_) } );
}

sub _pref {
    my ( $c, $key ) = @_;
    my $pref = $c->stash('pref');
    unless ( $pref->{$key} ) {
        my $e = "pref('$key') has not value.";
        $c->app->log->fatal($e);
        croak $e;
    }
    return $pref->{$key};
}

sub _service {
    my ( $c, $name ) = @_;
    $name = camelize($name) if $name =~ /^[a-z]/;
    Carp::croak 'Service name is empty.' unless $name;

    my $service = $c->app->{services}{$name};
    if ( Scalar::Util::blessed $service ) {
        $service->controller($c);
        Scalar::Util::weaken $service->{controller};
    }
    else {
        my $class = "Markets::Service::" . $name;
        _load_class($class);
        $service = $class->new($c);
        $c->app->{services}{$name} = $service;
    }
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

=head2 cookie_session

    $c->cookie_session( key => 'value' );
    my $value = $c->cookie_session('key');

Alias for $c->session;

=head2 pref

    my $hoge = $c->pref('hoge');

Get preference.

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

=head2 template

    $c->template('hoge/index');

Alias for $c->stash(template => 'hoge/index');

=head1 AUTHOR

Markets authors.
