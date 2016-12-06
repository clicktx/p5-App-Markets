package Markets::Addon::TestAddon;
use Mojo::Base 'Markets::Addon';

sub register {
    my ( $self, $app, $conf ) = @_;

    # Add hooks
    $self->add_action(
        'action_exsample_hook' => \&action_exsample_hook,
        { default_priority => 500 }
    );
    $self->add_action( 'action_exsample_hook' => \&action_exsample_hook, );
    $self->add_filter(
        'filter_exsample_hook' => \&filter_exsample_hook,
        { default_priority => 10 }
    );
    $self->add_filter( 'filter_exsample_hook' => \&filter_exsample_hook, );

    # Add hook and remove.
    $self->add_action( 'action_exsample_hook' => \&remove_action_hook, );
    $self->add_filter( 'filter_exsample_hook' => \&remove_filter_hook, );
    $self->remove_action('action_exsample_hook', 'remove_action_hook');
    $self->remove_filter('filter_exsample_hook', 'remove_filter_hook');

    # Add routes
    my $r = $self->routes;
    $r->get('/')->to('test_addon-example#top');
    $r->get('/hoo')->to('test_addon-example#hoo');

}

sub action_exsample_hook { my ( $c, $arg ) = @_ }
sub filter_exsample_hook { my ( $c, $arg ) = @_ }
sub remove_action_hook   { }
sub remove_filter_hook   { }

package Markets::Addon::TestAddon::Example;
use Mojo::Base 'Markets::Controller';

sub top { shift->render( text => 'top' ) }
sub hoo { shift->render( text => 'hoo' ) }

1;
