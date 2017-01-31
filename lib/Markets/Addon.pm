package Markets::Addon;
use Mojo::Base 'Mojolicious::Plugin';

use B;
use Carp 'croak';
use File::Spec;
use Mojolicious::Renderer;
use Mojo::Util qw/decamelize/;
use Mojo::File;
use constant {
    FORMAT  => 'html',
    HANDLER => 'ep',
};

has class_name => sub { ref shift };
has addon_name => sub {
    my $package = __PACKAGE__;
    shift->class_name =~ /${package}::(.*)/ and $1;
};
has routes => sub {
    my $self             = shift;
    my $addon_class_name = $self->class_name;
    $self->app->addons->installed->{$addon_class_name}->{routes}->to( namespace => __PACKAGE__ );
};
has 'app';

# Make addon home path
sub addon_home { Mojo::Home->new->detect(shift) }
sub register   { croak 'Method "register" not implemented by subclass' }

sub init {
    my $self = shift;
    my $app  = $self->app;

    # Load lexicon file.
    my $addons_dir  = $app->addons->dir;
    my $addon_name  = $self->addon_name;
    my $locale_dir  = File::Spec->catdir( $app->home, $addons_dir, $addon_name, 'locale' );
    my $text_domain = decamelize($addon_name);
    $app->lexicon(
        {
            search_dirs => [$locale_dir],
            data        => [ "*::$text_domain" => '*.po' ],    # set text domain
        }
    ) if -d $locale_dir;

    # Call to register method for YourAddon.
    $self->register($app);
}

sub add_action_hook { shift->_add_hook( 'action_hook', @_ ) }
sub add_filter_hook { shift->_add_hook( 'filter_hook', @_ ) }
sub rm_action_hook { shift->_remove_hook( 'action_hook', @_ ) }
sub rm_filter_hook { shift->_remove_hook( 'filter_hook', @_ ) }

sub _add_hook {
    my ( $self, $type, $name, $cb, $arg ) =
      ( shift, shift, shift, shift, shift // {} );
    my $addon_class_name = $self->class_name;

    my $addon          = $self->app->addons->installed->{$addon_class_name};
    my $hook_prioritie = $addon->{config}->{hook_priorities}->{$name};

    my $default_priority = $arg->{default_priority} || $self->app->addons->PRIORITY_DEFAULT;
    my $priority = $hook_prioritie ? $hook_prioritie : $default_priority;

    my $hooks      = $addon->{hooks};
    my $cb_fn_name = B::svref_2object($cb)->GV->NAME;

    push @{$hooks},
      {
        name             => $name,
        type             => $type,
        cb               => $cb,
        cb_fn_name       => $cb_fn_name,
        priority         => $priority,
        default_priority => $default_priority,
      };
}

sub _remove_hook {
    my ( $self, $type, $hook, $cb_fn_name ) = @_;
    my $remove_hooks = $self->app->addons->{remove_hooks};
    push @{$remove_hooks},
      {
        type       => $type,
        hook       => $hook,
        cb_fn_name => $cb_fn_name,
      };
}

sub install   { }
sub uninstall { }
sub update    { }

sub enable {

    # check: 現在enableなら処理をしない
}

sub disable {

    # check: 現在disableなら処理をしない
}

sub get_template {
    my ( $class, $template ) = @_;
    return 'Not argument, template path' unless $template;

    # Addon templates directory
    my $home = addon_home($class);
    my $templates_dir = File::Spec->catdir( $home, 'templates' );

    my $renderer = Mojolicious::Renderer->new;
    push @{ $renderer->classes }, $class;
    push @{ $renderer->paths },   $templates_dir;

    my $options = {
        template => $template,
        format   => FORMAT,
        handler  => HANDLER
    };

    # Try template
    if ( defined( my $path = $renderer->template_path($options) ) ) {
        Mojo::File::path($path)->slurp;
    }

    # Try DATA section
    elsif ( defined( my $d = $renderer->get_data_template($options) ) ) { $d }

    # No template
    else { "Not found template." }

}

=encoding utf8

=head1 NAME

Markets::Addon - Markets External plugin system

=head1 SYNOPSIS

  # YourAddon
  package Markets::Addon::YourAddon;
  use Mojo::Base 'Markets::Addon';

  sub init {
    my ($self, $app, $arg) = @_;

    # Your addon code here!
}

=head1 DESCRIPTION

L<Markets::Addon> is L<Mojolicious::Plugin> base plugin system.

=head1 ATRIBUTES

=head2 app

    my $app = $addon->app;

Return the application object.

=head2 class_name

    my $class_name = $addon->class_name;

Return the class name of addon.

=head2 addon_name

    my $addon_name = $addon->addon_name;

Return the addon name.


=head2 routes

    my $r = $addon->routes;

    # Markets::Addon::AddonName::Controller::action()
    # template AddonName/templates/addon_name/controller/action.html.ep
    $r->get('/')->to('addon_name-controller#action');

Return L<Mojolicious::Routes> object.

=head1 METHODS

=head2 addon_home

  # /path/to/Markets/addon/YourAddon
  &addon_home(Markets::Addon::YourAddon)

Get home path for YourAddon.

=head2 add_action_hook

    sub register {
        my my ( $self, $app, $arg ) = @_;
        $self->add_action_hook(
            'action_hook_name' => \&fizz,
            { default_priority => 500 }    # option
        );
    }

    sub fizz { ... }

Extend L<Markets> with action hook event.

=head2 add_filter_hook

    sub register {
        my my ( $self, $app, $arg ) = @_;
        $self->add_filter_hook(
            'filter_hook_name' => \&buzz,
            { default_priority => 500 }    # option
        );
    }

    sub buzz { ... }

Extend L<Markets> with filter hook event.

=head2 rm_action_hook

    $addon->rm_action_hook( 'action_hook_name', 'subroutine_name');

Remove L<Markets> action hook event.

=head2 rm_filter_hook

    $addon->rm_filter_hook( 'filter_hook_name', 'subroutine_name');

Remove L<Markets> filter hook event.

=head2 get_template

    my $content = $class->get_template('dir/template_name');

Get content for addon template file or DATA section.

format C<html> and handler C<ep> onry. ex) template_name.html.ep

=head2 init

This method will be called by L<Markets::Addon> at startup time.

=head2 register

This method will be called after L<Markets::Addon>::init() at startup time.
Meant to be overloaded in a subclass.

=head1 SEE ALSO

L<Markets::Addons> L<Mojolicious::Plugin>

=cut

1;
