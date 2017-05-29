package Markets::Addon::TestAddon;
use Mojo::Base 'Markets::Addon';

sub register {
    my ( $self, $app, $conf ) = @_;

    # Add triggers
    $self->trigger(
        'action_example_trigger' => \&action_example_trigger,
        { default_priority => 500 }
    );
    $self->trigger( 'action_example_trigger' => \&action_example_trigger, );
    $self->trigger(
        'filter_example_trigger' => \&filter_example_trigger,
        { default_priority => 10 }
    );
    $self->trigger( 'filter_example_trigger' => \&filter_example_trigger, );

    # Add trigger and remove.
    $self->trigger( 'action_example_trigger' => \&rm_act_trigger, );
    $self->trigger( 'filter_example_trigger' => \&rm_flt_trigger, );
    $self->rm_trigger('action_example_trigger', 'rm_act_trigger');
    $self->rm_trigger('filter_example_trigger', 'rm_flt_trigger');

    # Add routes
    my $r = $self->routes;
    $r->get('/test_addon')->to('test_addon-example#top');
    $r->get('/test_addon/hoo')->to('test_addon-example#hoo');

}

sub action_example_trigger { my ( $c, $arg ) = @_ }
sub filter_example_trigger { my ( $c, $arg ) = @_ }
sub rm_act_trigger   { }
sub rm_flt_trigger   { }

package Markets::Addon::TestAddon::Example;
use Mojo::Base 'Markets::Controller';

sub top { shift->render( text => 'top' ) }
sub hoo { shift->render( text => 'hoo' ) }

1;
