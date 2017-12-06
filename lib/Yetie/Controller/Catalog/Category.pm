package Yetie::Controller::Catalog::Category;
use Mojo::Base 'Yetie::Controller::Catalog';

sub index {
    my $self = shift;

    my $form = $self->form('search');
    $self->init_form();

    # return $self->render() unless $form->has_data;
    $form->do_validate;

    my $category_id = $self->stash('category_id');
    my $page_no     = $form->param('page') || 1;
    my $per_page    = $form->param('per_page') || 3;
    my $category    = $self->factory('category')->build( $category_id, { page => $page_no, rows => $per_page } );
    return $self->reply->not_found() unless $category->has_data;

    # widget category tree
    my $category_tree = $self->service('category_tree')->get_entity();
    $self->stash( 'yetie.widget.category_tree' => $category_tree );

    # content entity
    my $content = $self->app->factory('entity-content')->create(
        {
            title      => $category->title,
            breadcrumb => $category->breadcrumb,
            pager      => $category->products->pager,
            params     => $form->params,
        }
    );

    $self->stash(
        content  => $content,
        category => $category,
    );

    return $self->render();
}

1;
