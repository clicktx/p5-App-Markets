package Yetie::Controller::Catalog::Category;
use Mojo::Base 'Yetie::Controller::Catalog';

sub index {
    my $c = shift;

    my $form = $c->form('search');
    $c->init_form();

    # return $c->render() unless $form->has_data;
    $form->do_validate;

    my $category_id = $c->stash('category_id');
    my $category = $c->service('category')->find_category_with_products( $category_id, $form );
    $c->stash( entity => $category );

    # 404
    return $c->reply->not_found() unless $category->has_data;

    # Page Data
    $category->page_title( $category->title );

    # widget category tree
    my $service = $c->service('category_tree');
    $c->stash( 'yetie.widget.category_tree' => $service->search_all );

    return $c->render();
}

1;
