package Markets::Controller::Catalog::Product;
use Mojo::Base 'Markets::Controller::Catalog';

sub index {
    my $self       = shift;
    my $product_id = $self->stash('product_id');

    my $form = $self->form_set('product');
    $form->field('product_id')->value($product_id);

    my $product = $self->service('product')->create_entity($product_id);
    $self->stash( product => $product );

    my $validation = $self->validation;
    return $self->render() unless $validation->has_data;

    # Add to cart
    if ( $form->validate ) {
        $self->service('cart')->add_item( $form->params->to_hash );

        $self->flash( ref => $self->req->url->to_string );
        $self->redirect_to('RN_cart');
    }

    # Invalid
    $self->render();
}

1;
