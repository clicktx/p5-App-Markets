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
    return $self->reply->not_found() unless $category->has_data;

    # widget category tree
    my $service = $self->service('category_tree');
    my $category_tree = $service->get_cache || $service->search_all;
    $self->stash( 'yetie.widget.category_tree' => $category_tree );

    $self->stash( entity => $category );
    return $self->render();
}

1;
