package Markets::Web;
use Mojo::Base 'Markets::Core';
use Markets::Util qw(directories);

# This method will run once at server start
sub startup {
    my $self = shift;
    $self->initialize_app;

    # templets paths
    my $themes = directories( 'theme', { ignore => [ 'default', 'admin' ] } );
    say $self->dumper($themes); 
    $self->renderer->paths( [ 'theme/default', 'theme/admin' ] );

    # Routes
    $self->dispatcher('Markets::Admin::Dispatcher');
    $self->dispatcher('Markets::Web::Dispatcher');
}

1;
