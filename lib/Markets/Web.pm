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

    # Addons
    my $addons = directories('addons');
    say $self->dumper($addons); 
    $self->plugin($_) for @$addons;

    # Routes
    $self->dispatcher('Markets::Admin::Dispatcher');
    $self->dispatcher('Markets::Web::Dispatcher');
}

1;
