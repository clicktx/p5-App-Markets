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

    my $form = $self->form_set('admin-product');
    $self->init_form();

    return $self->render() if !$form->has_data or !$form->validate;

    my $rs = $self->schema->resultset('Product');

    return $self->render();
}

sub edit {
    my $self = shift;

    my $product_id = $self->stash('product_id');
    my $rs         = $self->schema->resultset('Product');
    my $product    = $rs->find($product_id);

    # init form
    my $form = $self->form_set('admin-product');
    $form->field('product_id')->required(1)->default_value($product_id);
    $form->field($_)->default_value( $product->$_ ) for $product->columns;
    $self->init_form();

    return $self->render() if !$form->has_data or !$form->validate;

    return $self->render();
}

1;
