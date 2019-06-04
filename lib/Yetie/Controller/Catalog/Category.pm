package Yetie::Controller::Catalog::Category;
use Mojo::Base 'Yetie::Controller::Catalog';

sub index {
    my $c = shift;

    my $form = $c->form('search');
    $c->init_form();
    $form->do_validate;

    my $category_id = $c->stash('category_id');
    my ( $category, $pager, $breadcrumbs ) =
      $c->service('category')->find_category_with_products( $category_id, $form );

    # 404
    return $c->reply->not_found() if !$category->has_id;

    # Page
    my $page = $c->factory('entity-page')->construct(
        title       => $category->title,
        form        => $form,
        breadcrumbs => $breadcrumbs,
        pager       => $pager,
    );

    # widget category tree
    $c->stash( 'yetie.widget.category_tree' => $c->service('category')->get_category_tree );

    return $c->render( page => $page, category => $category );
}

1;
