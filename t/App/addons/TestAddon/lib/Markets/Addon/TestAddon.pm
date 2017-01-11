package Markets::Addon::TestAddon;
use Mojo::Base 'Markets::Addon';

sub register {
    my ( $self, $app, $conf ) = @_;

    # Add hooks
    $self->add_action_hook(
        'action_example_hook' => \&action_example_hook,
        { default_priority => 500 }
    );
    $self->add_action_hook( 'action_example_hook' => \&action_example_hook, );
    $self->add_filter_hook(
        'filter_example_hook' => \&filter_example_hook,
        { default_priority => 10 }
    );
    $self->add_filter_hook( 'filter_example_hook' => \&filter_example_hook, );

    # Add hook and remove.
    $self->add_action_hook( 'action_example_hook' => \&rm_act_hook, );
    $self->add_filter_hook( 'filter_example_hook' => \&rm_flt_hook, );
    $self->rm_action_hook('action_example_hook', 'rm_act_hook');
    $self->rm_filter_hook('filter_example_hook', 'rm_flt_hook');

    # Add routes
    my $r = $self->routes;
    $r->get('/')->to('test_addon-example#top');
    $r->get('/hoo')->to('test_addon-example#hoo');

}

sub action_example_hook { my ( $c, $arg ) = @_ }
sub filter_example_hook { my ( $c, $arg ) = @_ }
sub rm_act_hook   { }
sub rm_flt_hook   { }

package Markets::Addon::TestAddon::Example;
use Mojo::Base 'Markets::Controller';

sub top { shift->render( text => 'top' ) }
sub hoo { shift->render( text => 'hoo' ) }

1;
