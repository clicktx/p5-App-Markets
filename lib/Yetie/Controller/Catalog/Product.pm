package Yetie::Controller::Catalog::Product;
use Mojo::Base 'Yetie::Controller::Catalog';

sub init_form {
    my ( $self, $form, $product_id ) = @_;

    $form->field('product_id')->value($product_id);
    return $self->SUPER::init_form();
}

sub index {
    my $self = shift;

    my $form       = $self->form_set('product');
    my $product_id = $self->stash('product_id');
    $self->init_form( $form, $product_id );

    my $product = $self->factory('product')->build($product_id);
    $self->stash( product => $product );

    # 404
    return $self->reply->not_found unless $product->title;

    my $validation = $self->validation;
    return $self->render() unless $validation->has_data;

    # Add to cart
    if ( $form->validate ) {
        $self->service('cart')->add_item( $form->params->to_hash );

        $self->flash( ref => $self->req->url->to_string );
        return $self->redirect_to('RN_cart');
    }

    # Invalid
    $self->render();
}

1;
