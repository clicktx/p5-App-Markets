package Yetie::Controller::Catalog::Product;
use Mojo::Base 'Yetie::Controller::Catalog';

sub init_form {
    my ( $c, $form, $product_id ) = @_;

    $form->field('product_id')->value($product_id);
    return $c->SUPER::init_form();
}

sub index {
    my $c = shift;

    # Initialize form
    my $form       = $c->form('product');
    my $product_id = $c->stash('product_id');
    $c->init_form( $form, $product_id );

    my ( $product, $breadcrumbs ) = $c->service('product')->find_product_with_breadcrumbs($product_id);

    # 404
    return $c->reply->not_found if !$product->has_id;

    # Page
    my $page = $c->factory('entity-page')->construct(
        title       => $product->title,
        form        => $form,
        breadcrumbs => $breadcrumbs,
    );

    $c->stash( page => $page, product => $product );

    # Page data
    # $product->page_title( $product->title );

    # Get request
    return $c->render() if $c->is_get_request;

    # Validation form
    return $c->render() if !$form->do_validate;

    # Add to cart
    $c->service('cart')->add_item( $form->params->to_hash );

    $c->flash( ref => $c->req->url->to_string );
    return $c->redirect_to('rn.cart');
}

1;
