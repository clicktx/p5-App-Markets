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
    say $self->dumper($themes);

    # unshift @{$self->renderer->paths}, 'themes/mytheme';

    # renderer
    $self->plugin('Markets::Plugin::EPRenderer');
    $self->plugin('Markets::Plugin::EPLRenderer');
    $self->plugin('Markets::Plugin::DOM');

    # regist enable addons
    my $enable_addons = $self->config->{addons}->{enable};
    foreach my $addon ( keys %{$enable_addons} ) {
        my $priorities = $enable_addons->{$addon};
        $self->plugin( $addon => $priorities );
    }

    # Routes
    $self->plugin('Markets::Admin::DispatchRoutes');
    $self->plugin('Markets::Web::DispatchRoutes');
}

1;
