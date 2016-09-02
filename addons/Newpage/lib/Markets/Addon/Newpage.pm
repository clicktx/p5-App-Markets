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

    say Dumper $r;

    # Add "templates" directory path.
    # push @{$app->renderer->paths}, 'addons/Newpage/templates';

    # Add class with templates in DATA section
    push @{ $app->renderer->classes }, 'Markets::Addon::Newpage';

    # Add routes in to the App.
    # $app->routes->add_child($r);

    # Remove routes for the App.
    # $app->routes->find($self->class_name)->remove;
}

1;

__DATA__

@@ newpage/example/welcome.html.ep
<h1>DATA <%= $msg %></h1>
<p>
    template: newpage/example/welcome.html.ep
</p>

@@ newpage/new/page.html.ep
<h1>DATA <%= $msg %></h1>
<p>
    template_name: newpage/new/page.html.ep
</p>
