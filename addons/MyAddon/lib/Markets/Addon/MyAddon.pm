package Markets::Addon::MyAddon;
use Mojo::Base 'Markets::Addon';

use Data::Dumper;

my $class = __PACKAGE__;
my $home  = $class->addon_home;    # get this addon home abs path.

sub register {
    my ( $self, $app, $conf ) = @_;

    $self->add_action_hook(
        action_replace_template => \&say_yes,
        { default_priority => 500 }    # option
    );
    $self->add_action_hook( action_replace_template => \&myaddon_replace_templates,
    );
    $self->add_filter_hook( filter_form => sub { say "hook! MyAddon filter_form!" }
    );

 # remove action hook example
 # $self->rm_action_hook('action_replace_template', 'say_yes');
 # $self->rm_action_hook('action_replace_template', 'myaddon_replace_templates');
}

sub say_yes {
    my ( $c, $file_path, $template_source ) = @_;
    say "hook say_yes: ";
    if ( $file_path =~ m|admin/index/welcome| ) {
        say "match -> $file_path";
        my $dom = $c->helpers->dom->parse( ${$template_source} );
        $dom->find('h1')->first->replace('<h1>Say yes!</h1>');

        # templateの書き換えを反映
        ${$template_source} = $dom;
    }
}

# 各フックポイントを関数で定義する

# コンパイル前のテンプレートに適用されるhook
sub myaddon_replace_templates {
    my ( $c, $file_path, $template_source ) = @_;
    say "filter hook: before_compile_template.";

    if ( $file_path =~ m|admin/index/welcome| ) {
        say "match  -> $file_path";

        # テンプレートを利用
        my $content = $class->get_template('welcome');

        # or DATA section
        # my $content =  $class->get_template('test');

        my $dom = $c->helpers->dom->parse( ${$template_source} );
        $dom->find('h2')->first->replace('<h2>MyAddon Mojolicious</h2>');
        $dom->find('h1')->first->replace('<h1>Admin mode from MyAddon</h1>');
        my $h2 = $dom->at('#admin-front')->content;
        $dom->at('#admin-front')->content( $h2 . ' / add text: ' . $content );

        ${$template_source} = $dom;
    }
    else {
        say "all templates rewiright!";
        # どのパスでも適用させる
        my $dom = $c->helpers->dom->parse( ${$template_source} );
        my $div = $dom->at('h2');
        $div->append_content(' rewright') if $div;

        ${$template_source} = $dom;
    }
}

# sub install   { }
# sub uninstall { }
# sub update    { }

sub enable {
    my $self = shift;    # my ($self, $app, $arg) = (shift, shift, shift // {});
    $self->SUPER::enable(@_);
}

sub disable {
    my $self = shift;
    $self->SUPER::disable(@_);
}

1;
__DATA__

@@ test.html.ep
<%= __begin_d 'my_addon' %>
<p>
    domain: <%= __ 'hello' %><%= __ 'hello2' %>
</p>
<%= __end_d %>
