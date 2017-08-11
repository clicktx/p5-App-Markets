package Markets::Controller::Admin::Product;
use Mojo::Base 'Markets::Controller::Admin';

has resultset => sub { shift->schema->resultset('Product') };

sub form_default_value {
    my ( $self, $form, $product_rs ) = @_;

    $form->field($_)->default_value( $product_rs->$_ ) for $product_rs->columns;
}

sub create {
    my $self = shift;

    my $form      = $self->form_set('admin-product');
    my $target_id = $self->req->param('duplicate_from');
    if ($target_id) {
        my $product = $self->resultset->find($target_id);
        $self->form_default_value( $form, $product );
    }
    $self->init_form();

    return $self->render() if $self->req->method eq 'GET';

    return $self->render() if !$form->has_data or !$form->validate;

    # Create new product
    my $data = $form->params->to_hash;
    $self->resultset->create($data);

    return $self->render();
}

sub delete {
    my $self = shift;

    my $product_id = $self->stash('product_id');
    $self->resultset->find($product_id)->delete;

    return $self->redirect_to('RN_admin_products');
}

sub edit {
    my $self = shift;

    my $product_id = $self->stash('product_id');
    my $product    = $self->resultset->find($product_id);

    # Init form
    my $form = $self->form_set('admin-product');
    $self->form_default_value( $form, $product );
    $self->init_form();

    return $self->render() if !$form->has_data or !$form->validate;

    # Update product
    my $data = $form->params->to_hash;
    $product->update($data);

    return $self->render();
}

1;
