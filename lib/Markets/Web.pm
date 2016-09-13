package Markets::Web;
use Mojo::Base 'Markets::Core';
use Markets::Util qw(directories);

# This method will run once at server start
sub startup {
    my $self = shift;
    $self->initialize_app;

    # templets paths
    $self->renderer->paths( [ 'themes/default', 'themes/admin' ] );
    my $themes = directories( 'themes', { ignore => [ 'default', 'admin' ] } );
    say $self->dumper($themes);    # debug

    # unshift @{$self->renderer->paths}, 'themes/mytheme';

    # renderer
    $self->plugin('Markets::Plugin::EPRenderer');
    $self->plugin('Markets::Plugin::EPLRenderer');
    $self->plugin('Markets::Plugin::DOM');

    # Routes
    $self->plugin('Markets::Admin::DispatchRoutes');
    $self->plugin('Markets::Web::DispatchRoutes');

    # Loading indtalled Addons
    my $addons_config = $self->model('data-configure')->addons;

    # Initialize all addons
    $self->addons->init($addons_config) unless $ENV{MOJO_ADDON_TEST_MODE};
}

1;
