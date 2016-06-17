package MyAddon;
use Mojo::Base 'Mojolicious::Plugin';

sub register {
    my ( $self, $app ) = @_;

    $app->helper( my_addon => sub { "MyAddon, Say!" } );
}

1;
