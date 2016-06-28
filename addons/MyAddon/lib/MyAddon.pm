package MyAddon;
use Mojo::Base 'Mojolicious::Plugin';

use Data::Dumper;

sub register {
    my ( $self, $app ) = @_;

    $app->helper( my_addon => sub { "MyAddon, Say!" } );

    # use before_compile_template
    $app->add_filter(
        before_compile_template => sub {
            my ( $c, $file_path, $template_source ) = @_;
        },
        {
            priority => 300,     #default 100
            config   => 'aaa',
        }
    );
    $app->add_filter(
        before_compile_template => sub {
            my ( $c, $file_path, $template_source ) = @_;
        },
        {
            priority => 10,      #default 100
            config   => 'aaa',
        }
    );
    $app->add_filter(
        before_compile_template => \&replace_content,
        { priority => 400 }
    );

  # after_render はhtml生成後に実行されるので毎回処理が走る
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
  #         my $h2 = $dom->at('#admin-front')->text;
  #         $dom->at('#admin-front')->content( $h2 . 'boo' );
  #         ${$output} = $dom;
  #     }
  # );
}

sub replace_content {
    my ( $c, $file_path, $template_source ) = @_;
    say "filter hook: before_compile_template.";

    if ( $file_path =~ m|admin/index/welcome| ) {
        say "  -> $file_path";

        my $dom = $c->helpers->dom->parse( ${$template_source} );
        $dom->find('h2')->first->replace('<h2>MyAddon Mojolicious</h2>');
        $dom->find('h1')->first->replace('<h1>Admin mode from MyAddon</h1>');
        my $h2 = $dom->at('#admin-front')->content;
        $dom->at('#admin-front')->content( $h2 . ' / add text' );

        ${$template_source} = $dom;
    }
}

1;
