package Markets::Addon::DisableAddon;
use Mojo::Base 'Markets::Addon';

sub register {
    my ( $self, $app, $conf ) = @_;

    $self->trigger(
        'action_example_hook' => \&action_example_hook,
        { default_priority => 1 }
    );
    $self->trigger(
        'filter_example_hook' => \&filter_example_hook,
        { default_priority => 1 }
    );

    $self->trigger( 'action_disable_hook' => sub {} );
    $self->trigger( 'filter_disable_hook' => sub {} );

    my $r = $self->routes;
    $r->get('/')->to('test_addon-example#welcome');
}

sub action_example_hook {
    my ( $c, $arg ) = @_;
}

sub filter_example_hook {
    my ( $c, $arg ) = @_;
}

package Markets::Addon::TestAddon::Example;
use Mojo::Base 'Markets::Controller';

sub welcome { shift->render( text => 'welcome' ) }
1;

__DATA__

@@ disable_addon/example/welcome.html.ep
Welcome
