package Yetie::Controller::Catalog::Category;
use Mojo::Base 'Yetie::Controller::Catalog';

sub index {
    my $self = shift;

    my $form = $self->form_set();
    $self->init_form();

    # return $self->render() unless $form->has_data;
    $form->validate;

    my $category_id = $self->stash('category_id');
    my $page_no     = $form->param('p') || 1;
    my $rows        = 3;
    my $category    = $self->factory('category')->build( $category_id, { page => $page_no, rows => $rows } );
    return $self->reply->not_found() unless $category->id;

    # widget category tree
    my $category_tree = $self->service('category_tree')->get_entity();
    $self->stash( 'yetie.widget.category_tree' => $category_tree );

    # content entity
    my $content = $self->app->factory('entity-content')->create(
        {
            title => $category->title,
            # breadcrumb => $category->breadcrumb,
            pager  => $category->products->pager,
            params => $form->params,
        }
    );

    $self->stash(
        content  => $content,
        category => $category,
    );

    return $self->render();
}

1;
