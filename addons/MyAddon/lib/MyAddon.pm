package MyAddon;
use Mojo::Base 'Mojolicious::Plugin';
use Mojo::DOM;

sub register {
    my ( $self, $app ) = @_;

    $app->helper( my_addon => sub { "MyAddon, Say!" } );
    $app->hook(
        before_welcome => sub {
            my $c = shift;
            say "hook, before_welcome.";
        }
    );

    $app->hook(
        after_render => sub {
            my ( $c, $output, $format ) = @_;
            # say $c->dumper( $c->tx );

            say 'route: ' . $c->stash('controller') . '#' . $c->stash('action');

            my $dom = Mojo::DOM->new( ${$output} );
            $dom->find('h2')->first->replace('<h2>MyAddon Mojolicious</h2>');
            ${$output} = $dom;
        }
    );
}

1;
