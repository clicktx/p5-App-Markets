package Markets::Web;
use Mojo::Base 'Markets';

# This method will run once at server start
sub startup {
    my $self = shift;

    # Documentation browser under "/perldoc"
    $self->plugin('PODRenderer');

    # Routes
    $self->dispatcher('Markets::Web::Dispatcher');

}

1;
