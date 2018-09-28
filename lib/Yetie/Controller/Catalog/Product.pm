package Yetie::Controller::Catalog::Product;
use Mojo::Base 'Yetie::Controller::Catalog';

sub init_form {
    my ( $c, $form, $product_id ) = @_;

    $form->field('product_id')->value($product_id);
    return $c->SUPER::init_form();
}

sub index {
    my $c = shift;

    my $form       = $c->form('product');
    my $product_id = $c->stash('product_id');
    $c->init_form( $form, $product_id );

    my $product = $c->service('product')->find_product_with_breadcrumbs($product_id);
    $c->stash( entity => $product );

    # Page data
    $product->page_title( $product->title );

    # 404
    return $c->reply->not_found unless $product->has_data;

    my $validation = $c->validation;
    return $c->render() unless $validation->has_data;

    # Add to cart
    if ( $form->do_validate ) {
        $c->service('cart')->add_item( $form->params->to_hash );

        $c->flash( ref => $c->req->url->to_string );
        return $c->redirect_to('RN_cart');
    }

    # Invalid
    $c->render();
}

1;
