package Markets::Controller::Catalog::Category;
use Mojo::Base 'Markets::Controller::Catalog';

sub index {
    my $self = shift;

    my $form = $self->form_set();
    $self->init_form();

    # return $self->render() unless $form->has_data;
    $form->validate;

    my $category_id = $self->stash('category_id');
    my $page_no     = $form->param('p') || 1;
    my $row         = 3;
    my $category    = $self->service('category')->create_entity( $category_id, $page_no, $row );
    return $self->reply->not_found() unless $category;

    # Category tree
    # NOTE: 階層やカテゴリ数によってSQLが多く実行されるためキャッシュした方が良い
    my $category_tree = $self->service('category_tree')->create_entity();
    $self->stash( category_tree => $category_tree );

    # content entity
    my $content = $self->app->factory('entity-content')->create(
        {
            title      => $category->title,
            breadcrumb => $category->breadcrumb,
            pager      => $category->products->pager,
            params     => $form->params->to_hash,
        }
    );

    $self->stash(
        content  => $content,
        products => $category->products,
    );

    return $self->render();
}

1;
