package Yetie::Controller::Admin::Product;
use Mojo::Base 'Yetie::Controller::Admin';

sub form_default_value {
    my ( $self, $form, $entity ) = @_;
    $form->field($_)->default_value( $entity->$_ ) for qw(id price title description);
}

sub create {
    my $self = shift;

    my $new_product = $self->service('product')->new_product();
    $self->stash( product_id => $new_product->id );

    $self->template('admin/product/edit');
    return $self->edit();
}

sub delete {
    my $self = shift;

    my $product_id     = $self->stash('product_id');
    my $delete_product = $self->service('product')->remove_product($product_id);

    return $delete_product
      ? $self->redirect_to('RN_admin_products')
      : $self->reply->exception( $self->__('Failed to delete product.') );
}

sub duplicate {
    my $self = shift;

    my $product_id = $self->stash('product_id');
    my $result     = $self->service('product')->duplicate_product($product_id);
    return $result ? $self->redirect_to('RN_admin_products') : $self->reply->not_found();
}

sub edit {
    my $self = shift;

    my $product_id = $self->stash('product_id');
    my $entity     = $self->factory('product')->build($product_id);
    return $self->reply->not_found() unless $entity->has_data;

    # Init form
    my $form = $self->form('admin-product');
    $self->form_default_value( $form, $entity );

    my $categories = $self->service('product')->choices_primary_category($entity);
    $form->field('primary_category')->choices($categories);
    $self->init_form();

    return $self->render() if !$form->has_data or !$form->validate;

    # Update data
    $self->service('product')->update_product( $product_id, $form->params->to_hash );
    return $self->render();
}

sub category {
    my $self = shift;

    my $product_id = $self->stash('product_id');
    my $entity     = $self->factory('product')->build($product_id);
    return $self->reply->not_found() unless $entity->has_data;

    # Init form
    my $form = $self->form('admin-product');

    my $category_ids = [];
    $entity->product_categories->each( sub { push @{$category_ids}, $_->category_id } );

    my $category_choices = $self->service('category')->get_category_choices($category_ids);
    $form->field('categories')->choices($category_choices);
    $self->init_form();

    return $self->render() if !$form->has_data or !$form->validate;

    # Selected categories
    my $category_ids = $form->param('categories[]');
    return $self->render() unless @{$category_ids};

    my $primary_category_id = @{ $entity->product_categories } ? $entity->product_categories->first->category_id : '';
    $self->service('product')->update_product_categories( $product_id, $category_ids, $primary_category_id );
    return $self->render();
}

1;
