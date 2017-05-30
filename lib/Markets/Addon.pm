package Markets::Addon;
use Mojo::Base 'Mojolicious::Plugin';

use Class::C3;
use B;
use Sub::Util qw/subname set_subname/;
use Carp 'croak';
use Mojo::Util qw/camelize decamelize/;
use Mojo::Loader qw/load_class/;
use constant {
    FORMAT  => 'html',
    HANDLER => 'ep',
};

has class_name => sub { ref shift };
has name => sub {
    my $package = __PACKAGE__;
    shift->class_name =~ /${package}::(.*)/ and decamelize $1;
};
has [qw/app config is_enabled routes/];
has triggers => sub { [] };

# Make addon home path
sub addon_home { Mojo::Home->new->detect(shift) }

sub disable {

    # check: 現在disableなら処理をしない
}

sub enable {

    # check: 現在enableなら処理をしない
}

sub get_template {
    my ( $class, $template ) = @_;
    return 'Not argument, template path' unless $template;

    # Addon templates directory
    my $home = addon_home($class);
    my $templates_dir = Mojo::File::path( $home, 'templates' );

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

sub install {
    my $self = shift;

    # Create Tables
    my $class_name   = ref $self;
    my $schema_class = $class_name . "::Schema";

    if ( my $e = load_class $schema_class ) {
        die "Exception: $e" if ref $e;
    }
    else {
        my $schema       = $self->app->schema;
        my $connect_info = $schema->storage->connect_info;
        my $self_schema  = $schema_class->connect( $connect_info->[0] );
        $self_schema->deploy;
    }
    return $self;
}

sub new {
    my $self = shift;
    $self = $self->SUPER::new(@_);
    Scalar::Util::weaken $self->{app};
    return $self;
}

sub register { croak 'Method "register" not implemented by subclass' }

sub rm_trigger { shift->_remove_trigger(@_) }

sub setup {
    my $self = shift;

    # Routes
    my $class_name = $self->class_name;
    my $r          = Mojolicious::Routes->new;
    $r = $r->to( namespace => __PACKAGE__ )->name($class_name);
    $self->routes($r);

    # Load lexicon file.
    my $addon_home = addon_home($class_name);
    my $addon_name = $self->name;
    my $locale_dir = Mojo::File::path( $addon_home, 'locale' );
    $self->app->lexicon(
        {
            search_dirs => [$locale_dir],
            data        => [ "*::$addon_name" => '*.po' ],    # set text domain
        }
    ) if -d $locale_dir;

    # Load schema
    # TODO: $self->is_installed を作って真の場合のみ実行させる？
    my $result_class = $class_name . "::Schema::Result";
    $self->app->schema->storage->schema->load_namespaces( result_namespace => "+$result_class" );

    # Call to register method for YourAddon.
    $self->register( $self->app );
    return $self;
}

sub trigger { shift->_add_trigger(@_) }

sub uninstall { }
sub update    { }

sub _add_trigger {
    my ( $self, $name, $cb, $opt ) = ( shift, shift, shift, shift // {} );

    my $trigger_priority = $self->{config}->{trigger_priorities}->{$name};
    my $default_priority = $opt->{default_priority} || $self->app->addons->trigger->DEFAULT_PRIORITY;
    my $priority         = $trigger_priority ? $trigger_priority : $default_priority;
    my $cb_sub_name      = subname($cb);

    push @{ $self->triggers },
      {
        name             => $name,
        cb               => $cb,
        cb_sub_name      => $cb_sub_name,
        priority         => $priority,
        default_priority => $default_priority,
      };
}

sub _remove_trigger {
    my ( $self, $trigger, $cb_sub_name ) = @_;
    my $array = $self->app->addons->trigger->remove_list;
    push @{$array},
      {
        trigger     => $trigger,
        cb_sub_name => $cb_sub_name,
      };
}

=encoding utf8

=head1 NAME

Markets::Addon - Markets External plugin system

=head1 SYNOPSIS

  # YourAddon
  package Markets::Addon::YourAddon;
  use Mojo::Base 'Markets::Addon';

  sub register {
    my ($self, $app, $arg) = @_;

    # Your addon code here!
}

=head1 DESCRIPTION

L<Markets::Addon> is L<Mojolicious::Plugin> base plugin system.

=head1 ATRIBUTES

=head2 C<app>

    my $app = $addon->app;

Return the application object.

=head2 C<class_name>

    my $class_name = $addon->class_name;

Return the class name of addon.

=head2 C<name>

    my $addon_name = $addon->name;

Return the addon name.

=head2 C<is_enabled>

Return boolean.

=head2 C<routes>

    my $r = $addon->routes;

    # Markets::Addon::AddonName::Controller::action()
    # template AddonName/templates/addon_name/controller/action.html.ep
    $r->get('/')->to('addon_name-controller#action');

Return L<Mojolicious::Routes> object.

=head1 METHODS

L<Markets::Addon> inherits all methods from L<Mojolicious::Plugin> and
implements the following new ones.

=head2 C<addon_home>

  # /path/to/Markets/addon/YourAddon
  &addon_home(Markets::Addon::YourAddon)

Get home path for YourAddon.

=head2 C<get_template>

    my $content = $class->get_template('dir/template_name');

Get content for addon template file or DATA section.

format C<html> and handler C<ep> onry. ex) template_name.html.ep

=head2 C<register>

This method will be called after L<Markets::Addon>::setup() at startup time.
Meant to be overloaded in a subclass.

=head2 C<rm_trigger>

    $addon->rm_trigger( 'trigger_name', 'subroutine_name');

Remove L<Markets> trigger event.

=head2 C<setup>

This method will be called by L<Markets::Addon> at startup time.

=head2 C<trigger>

    sub register {
        my my ( $self, $app, $arg ) = @_;
        $self->trigger(
            trigger_name => \&fizz,
            { default_priority => 500 }    # option
        );
        $self->trigger( tirgger2 => sub { say "trigger2" }, { default_priority => 300 } );
    }

    sub fizz { say "trigger" }

Extend L<Markets> trigger event.

=head1 SEE ALSO

L<Markets::Addons> L<Mojolicious::Plugin>

=cut

1;
