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

    my $title = $category ? $category->title : $category_name;
    $self->stash( title => $title );
    $self->render();
}

1;
