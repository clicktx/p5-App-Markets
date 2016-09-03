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

    # Add routes
    my $r = $self->routes;
    $r->get('/')->to('test_addon-example#top');
    $r->get('/hoo')->to('test_addon-example#hoo');

    # Add class with templates in DATA section
    push @{ $app->renderer->classes }, 'Markets::Addon::TestAddon::Example';
}

sub action_exsample_hook { my ( $c, $arg ) = @_ }
sub filter_exsample_hook { my ( $c, $arg ) = @_ }

package Markets::Addon::TestAddon::Example;
use Mojo::Base 'Mojolicious::Controller';

sub top { shift->render( msg => 'top' ) }
sub hoo { shift->render( msg => 'hoo' ) }

1;
__DATA__

@@ test_addon/example/top.html.ep
<%= $msg %>

@@ test_addon/example/hoo.html.ep
<%= $msg %>
