package Markets::Addon;
use Mojo::Base 'Mojolicious::Plugin';
use Carp 'croak';
use File::Spec;
use Mojolicious::Renderer;
use Mojo::Util qw/slurp/;
use constant {
    FORMAT  => 'html',
    HANDLER => 'ep',
};

has 'app';

# Make addon home path
sub addon_home { Mojo::Home->new->detect(shift) }
sub register   { croak 'Method "register" not implemented by subclass' }

sub init {
    my $self = shift;
    my $app  = $self->app;
    $self->register($app);
}

sub add_action {
    my $caller = ( caller 1 )[3];
    shift->_add_hook( $caller, 'action', @_ );
}

sub add_filter {
    my $caller = ( caller 1 )[3];
    shift->_add_hook( $caller, 'filter', @_ );
}

sub _add_hook {
    my ( $self, $caller, $hook_type, $hook_name, $cb, $arg ) =
      ( shift, shift, shift, shift, shift, shift // {} );
    my ( $addon_name, $function ) = $caller =~ /(.*)::(.*)/;

    my $addon          = $self->app->stash('addons')->{$addon_name};
    my $hook_prioritie = $addon->{config}->{hook_priorities}->{$hook_name};

    my $default_priority =
      $arg->{default_priority} || $self->app->addons->PRIORITY_DEFAULT;
    my $priority = $hook_prioritie ? $hook_prioritie : $default_priority;

    my $hooks = $addon->{hooks};
    push @{$hooks},
      {
        name             => $hook_name,
        type             => $hook_type,
        cb               => $cb,
        priority         => $priority,
        default_priority => $default_priority,
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
        slurp $path;
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

=head1 METHODS

=head2 addon_home

  # /path/to/Markets/addon/YourAddon
  &addon_home(Markets::Addon::YourAddon)

Get home path for YourAddon.

=head2 add_action

    sub register {
        my my ( $self, $app, $arg ) = @_;
        $self->add_action(
            'action_hook_name' => \&fizz,
            { default_priority => 500 }    # option
        );
    }

    sub fizz { ... }

Extend L<Markets> with action hook event.

=head2 add_filter

    sub register {
        my my ( $self, $app, $arg ) = @_;
        $self->add_filter(
            'filter_hook_name' => \&buzz,
            { default_priority => 500 }    # option
        );
    }

    sub buzz { ... }

Extend L<Markets> with filter hook event.

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
