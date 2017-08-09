package Markets::Controller::Admin::Product;
use Mojo::Base 'Markets::Controller::Admin';

# sub init_form {
#     my ( $self, $form, $rs ) = @_;
#
#     $form->field('product_id')->value('111');
#     return $self->SUPER::init_form();
# }

sub create {
    my $self = shift;
    return $self->render();
}

sub edit {
    my $self = shift;

    my $product_id = $self->stash('product_id');
    my $rs         = $self->schema->resultset('Product');
    my $product    = $rs->find($product_id);

    my $form = $self->form_set('admin-product');
    $form->field($_)->value( $product->$_ ) for $product->columns;
    $self->init_form();

    return $self->render() unless $form->has_data;

    return $self->render();
}

1;
