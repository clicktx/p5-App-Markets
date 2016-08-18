package Addon::MyAddon;
use Mojo::Base 'Markets::Addon';

use Data::Dumper;

# 各フックポイントを関数で定義する
sub filter_before_compile_template {
    my ( $c, $file_path, $template_source ) = @_;
    say "filter hook: before_compile_template.";

    if ( $file_path =~ m|admin/index/welcome| ) {
        say "  -> $file_path";

        my $dom = $c->helpers->dom->parse( ${$template_source} );
        $dom->find('h2')->first->replace('<h2>MyAddon Mojolicious</h2>');
        $dom->find('h1')->first->replace('<h1>Admin mode from MyAddon</h1>');
        my $h2 = $dom->at('#admin-front')->content;
        $dom->at('#admin-front')->content( $h2 . ' / add text: ' . "<%= __d 'my_addon', 'hello' %>");

        ${$template_source} = $dom;
    }
}

1;
