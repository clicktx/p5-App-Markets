package Markets::Controller::Admin::Category;
use Mojo::Base 'Markets::Controller::Admin';

sub index {
    my $self = shift;

    my $tree = $self->app->schema->resultset('Category')->get_tree;
    use DDP;
    p $tree;
    $self->render( tree => $tree );
}

1;
