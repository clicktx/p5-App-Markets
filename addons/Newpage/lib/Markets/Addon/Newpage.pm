package Markets::Addon::Newpage;
use Mojo::Base 'Markets::Addon';
use Data::Dumper;

my $class = __PACKAGE__;           # or $class = ref $self;
my $home  = $class->addon_home;    # get this addon home abs path.

sub register {
    my ( $self, $app, $conf ) = @_;
    my $r = $self->routes;

    # or $r->get('/')->to('Newpage::Example#welcome');
    $r->get('/')->to('newpage-example#welcome');

    $r->get('/page')
      ->to( 'Newpage::Example#welcome', template => 'newpage/new/page', );

    # Add "templates" directory path.
    # push @{$app->renderer->paths}, 'addons/Newpage/templates';

    # Add class with templates in DATA section
    push @{ $app->renderer->classes }, 'Markets::Addon::Newpage';

    # Add link
    $self->add_action( action_replace_template => \&action_replace_template, );
}

sub action_replace_template {
    my ( $c, $file_path, $template_source ) = @_;

    if ( $file_path =~ m|default/example/welcome| ) {

        my $dom = $c->helpers->dom->parse( ${$template_source} );
        $dom->find('p')
          ->last->append( "<h2>Newpage</h2>"
              . "<p><%= link_to 'newpage' => '/newpage' %></p>" );
        ${$template_source} = $dom;
    }
}

1;

__DATA__

@@ newpage/example/welcome.html.ep
% layout 'default';
% title 'make page from Newpage addon';

<h1>DATA <%= $msg %></h1>
<p>
    template: newpage/example/welcome.html.ep
</p>
<p>
    <li>link: <%= link_to 'top' => '/' %></li>
    <li>link: <%= link_to 'ja' => '/ja' %> <%= link_to 'en' => '/en' %></li>
    <li>link: <%= link_to 'page' => 'page' %></li>
</p>

@@ newpage/new/page.html.ep
<h1>DATA <%= $msg %></h1>
<p>
    template_name: newpage/new/page.html.ep
</p>
<p>
    <li>link: <%= link_to 'top' => '/' %></li>
    <li>link: <%= link_to 'ja' => '/ja' %> <%= link_to 'en' => '/en' %></li>
    <li>link: <%= link_to 'newpage' => '/newpage' %></li>
</p>
