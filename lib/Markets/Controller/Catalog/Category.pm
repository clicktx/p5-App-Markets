package Markets::Controller::Catalog::Category;
use Mojo::Base 'Markets::Controller::Catalog';

sub index {
    my $self = shift;

    my $category_id   = $self->stash('category_id');
    my $category_name = $self->stash('category_name');

    my $rs = $self->app->schema->resultset('Category');
    $self->stash( rs => $rs );

    my $category;
    $category = $rs->find($category_id) if $category_id;

    $self->stash( title => $category->title ) if $category;
    $self->render();
}

1;
