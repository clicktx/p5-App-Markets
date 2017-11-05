package Yetie::Addon::DisableAddon;
use Mojo::Base 'Yetie::Addon';

sub register {
    my ( $self, $app, $conf ) = @_;

    $self->trigger(
        'action_example_trigger' => \&action_example_trigger,
        { default_priority => 1 }
    );
    $self->trigger(
        'filter_example_trigger' => \&filter_example_trigger,
        { default_priority => 1 }
    );

    $self->trigger( 'action_disable_trigger' => sub {} );
    $self->trigger( 'filter_disable_trigger' => sub {} );

    my $r = $self->routes;
    $r->get('/')->to('test_addon-example#welcome');
}

sub action_example_trigger {
    my ( $c, $arg ) = @_;
}

sub filter_example_trigger {
    my ( $c, $arg ) = @_;
}

package Yetie::Addon::TestAddon::Example;
use Mojo::Base 'Yetie::Controller';

sub welcome { shift->render( text => 'welcome' ) }
1;

__DATA__

@@ disable_addon/example/welcome.html.ep
Welcome
