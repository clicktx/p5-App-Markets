package MyAddon;
use Mojo::Base 'Mojolicious::Plugin';
use Mojo::DOM;

use Data::Dumper;

has dom => sub { Mojo::DOM->new };

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
        prefilter_transform => sub {
            my ( $c, $path, $template ) = @_;
            say "prefilter_transform.";
            say $c;
            say $path;
            # say Dumper $template;

            # say Dumper $mt, $template;
            if ( $path =~ m|admin/index/welcome| ) {
                say "template is admin/index/welcome +++++++++++++++";
                my $b = Mojo::ByteStream->new(${$template});
                my $dom = $self->dom->parse( $b );
                # $dom->find('h2')->first->replace('<h2>MyAddon Mojolicious MojoMojo</h2>');
                say ${$template};
                # ${$template} = $dom;
            }

            # elsif ( $mt->{name} =~ m|layouts/default| ) {
            #     say "template id default/layouts/default";
            # } else {
            #     say "don't match";
            #     say $mt->{name};
            # }
        }
    );

    # $app->hook(
    #     after_render => sub {
    #         my ( $c, $output, $format ) = @_;
    # 
    #         # say $c->dumper( $c->tx );
    # 
    #         say 'route: ' . $c->stash('controller') . '#' . $c->stash('action');
    # 
    #         my $dom = Mojo::DOM->new( ${$output} );
    #         $dom->find('h2')->first->replace('<h2>MyAddon Mojolicious</h2>');
    #         ${$output} = $dom;
    #     }
    # );
}

1;
