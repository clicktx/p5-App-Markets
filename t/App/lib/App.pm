package App;
use Mojo::Base 'Yetie';

sub initialize_app {
    my $self = shift;

    # load config file
    my $home        = $self->home;
    my $config_path = $home->rel_file("../../config/test.conf");
    $self->plugin( Config => { file => $config_path } );

    $self->SUPER::initialize_app(@_);
}

1;
