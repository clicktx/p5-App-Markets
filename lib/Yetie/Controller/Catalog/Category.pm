package Yetie::Controller::Catalog::Category;
use Mojo::Base 'Yetie::Controller::Catalog';

sub index {
    my $self = shift;

    my $form = $self->form('search');
    $self->init_form();

    # return $self->render() unless $form->has_data;
    $form->do_validate;

    my $category_id = $self->stash('category_id');
    my $category = $self->service('category')->find_category_with_products( $category_id, $form );
    $self->stash( entity => $category );

    # 404
    return $self->reply->not_found() unless $category->has_data;

    # Page Data
    $category->page_title( $category->title );

    # widget category tree
    my $service = $self->service('category_tree');
    my $category_tree = $service->get_cache || $service->search_all;
    $self->stash( 'yetie.widget.category_tree' => $category_tree );

    return $self->render();
}

1;
