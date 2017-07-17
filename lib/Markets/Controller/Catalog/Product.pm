package Markets::Controller::Catalog::Product;
use Mojo::Base 'Markets::Controller::Catalog';

sub index {
    my $self       = shift;
    my $product_id = $self->stash('product_id');

    my $form = $self->form_set('product');
    $form->field('product_id')->value($product_id);

    my $product = $self->service('product')->create_entity($product_id);
    $self->render( product => $product );
}

sub add_to_cart {
    my $self = shift;

    die unless $self->service('cart')->add_item;

    use DDP;
    p $self->cart->to_data;    # debug

    $self->flash( ref => $self->req->url->to_string );
    $self->redirect_to('RN_cart');
}

1;
