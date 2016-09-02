package Markets::Addons;
use Mojo::Base 'Markets::EventEmitter';

use Carp qw/croak/;
use Mojo::Loader 'load_class';
use Mojo::Util 'camelize';
use Mojolicious::Routes;
use constant { PRIORITY_DEFAULT => '100' };

has namespaces => sub { ['Markets::Addon'] };
has action     => sub { Markets::Addons::Action->new };
has filter     => sub { Markets::Addons::Filter->new };
has 'app';

sub _on         { shift->on(@_) }
sub emit_action { shift->emit(@_) }
sub emit_filter { shift->emit(@_) }

sub subscribe_hooks {
    my ( $self, $addon_name ) = @_;
    my $hooks = $self->app->stash('addons')->{$addon_name}->{hooks};
    foreach my $hook ( @{$hooks} ) {
        my $hook_type = $hook->{type};
        $self->$hook_type->_on($hook);
    }
}

sub is_enabled {
    my ( $self, $addon_name ) = @_;
    my $addons = $self->app->stash('addons');
    $addons->{$addon_name}->{is_enabled};
}

sub init {
    my ( $self, $addon_settings ) = ( shift, shift // {} );
    my $app = $self->app;

    # Add all addons data in the app->stash.
    $app->defaults( addons => $addon_settings );

    my $addons = $app->stash('addons');
    foreach my $addon_name ( keys %{$addons} ) {

        # Initialize routes
        $self->init_routes($addon_name);

        # Initialize hooks
        # $self->xxx

        # Regist addon
        $app->register_addon($addon_name);

        # For the enabled addons
        $self->enabled($addon_name) if $self->is_enabled($addon_name);
    }
}

sub init_routes {
    my ( $self, $name ) = @_;
    $self->app->stash('addons')->{$name}->{routes} = Mojolicious::Routes->new;
}

sub enabled {
    my ( $self, $addon_name ) = @_;

    # Add hooks into the App.
    $self->subscribe_hooks($addon_name);

    # Add routes in to the App.
    $self->on_routes($addon_name);
}

sub on_routes {
    my ( $self, $addon_name ) = @_;
    my $routes = $self->app->stash('addons')->{$addon_name}->{routes};
    $self->app->routes->add_child($routes) if @{ $routes->children };
}

###################################################
###  loading plugin code from Mojolicous::Plugins
###################################################
sub load_addon {
    my ( $self, $name ) = @_;

    # Try all namespaces and full module name
    my $suffix = $name =~ /^[a-z]/ ? camelize $name : $name;
    my @classes = map { "${_}::$suffix" } @{ $self->namespaces };
    for my $class ( @classes, $name ) {
        return $class->new( app => $self->app ) if _load($class);
    }

    # Not found
    die qq{Addon "$name" missing, maybe you need to install it?\n};
}

sub register_addon {
    shift->load_addon(shift)->init( ref $_[0] ? $_[0] : {@_} );
}

sub _load {
    my $module = shift;
    return $module->isa('Markets::Addon')
      unless my $e = load_class $module;
    ref $e ? die $e : return undef;
}

###################################################

# Use separate namespace
package Markets::Addons::Action;
use Mojo::Base 'Markets::Addons';

package Markets::Addons::Filter;
use Mojo::Base 'Markets::Addons';

1;

=encoding utf8

=head1 NAME

Markets::Addons - Addon manager for Markets

=head1 SYNOPSIS


=head1 DESCRIPTION

L<Markets::Addons> is L<Mojolicious::Plugins> Based.
This module is addon maneger of Markets.

=head1 EVENTS

L<Markets::Addons> inherits all events from L<Mojo::EventEmitter> & L<Markets::EventEmitter>.

=head1 ATTRIBUTES

=head2 app

    my $app = $addons->app;

Return the application object.

=head2 action

Markets::Addons::Action object.

=head2 filter

Markets::Addons::Filter object.

=head1 METHODS

=head2 init

    $addons->init(\%addon_settings);

=head2 subscribe_hooks

    $addons->subscribe_hooks('Markets::Addon::MyAddon');


Subscribe to C<Markets::Addons::Action> or C<Markets::Addons::Filter> event.

=head1 SEE ALSO

L<Markets::EventEmitter> L<Mojolicious::Plugins> L<Mojo::EventEmitter>

=cut
