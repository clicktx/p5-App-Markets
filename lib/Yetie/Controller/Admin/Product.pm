package Yetie::Controller::Admin::Product;
use Mojo::Base 'Yetie::Controller::Admin';

sub form_default_value {
    my ( $c, $form, $entity ) = @_;
    $form->field($_)->default_value( $entity->$_ ) for qw(id price title description);
}

sub create {
    my $c = shift;

    my $new_product = $c->service('product')->new_product();
    $c->stash( product_id => $new_product->id );

    $c->template('admin/product/edit');
    return $c->edit();
}

sub delete {
    my $c          = shift;
    my $product_id = $c->stash('product_id');

    # 販売済みの商品は削除不可
    my $bool = $c->service('product')->is_sold($product_id);
    return $c->reply->exception('Could not delete item.This item has already been sold.') if $bool;

    my $delete_product = $c->service('product')->remove_product($product_id);
    return $delete_product
      ? $c->redirect_to('RN_admin_products')
      : $c->reply->not_found();
}

sub duplicate {
    my $c = shift;

    my $product_id = $c->stash('product_id');
    my $result     = $c->service('product')->duplicate_product($product_id);
    return $result ? $c->redirect_to('RN_admin_products') : $c->reply->not_found();
}

sub edit {
    my $c = shift;

    my $product_id = $c->stash('product_id');
    my $entity     = $c->service('product')->find_product($product_id);
    return $c->reply->not_found() unless $entity->has_data;

    # Init form
    my $form = $c->form('admin-product');
    $c->form_default_value( $form, $entity );

    my $categories = $c->service('product')->choices_primary_category($entity);
    $form->field('primary_category')->choices($categories);
    $c->init_form();

    return $c->render() if !$form->has_data or !$form->do_validate;

    # Update data
    $c->service('product')->update_product( $product_id, $form->params->to_hash );
    return $c->render();
}

sub category {
    my $c = shift;

    my $product_id = $c->stash('product_id');
    my $entity     = $c->service('product')->find_product($product_id);
    return $c->reply->not_found() unless $entity->has_data;

    # Init form
    my $form = $c->form('admin-product-category');

    my $category_ids = [];
    $entity->product_categories->each( sub { push @{$category_ids}, $_->category_id } );

    my $category_choices = $c->schema->resultset('Category')->get_category_choices($category_ids);
    $form->field('categories[]')->choices($category_choices);
    $c->init_form();

    return $c->render() if !$form->has_data or !$form->do_validate;

    # Selected categories
    my $selected_categories = $form->every_param('categories[]');
    return $c->render() unless @{$selected_categories};

    my $primary_category_id = @{ $entity->product_categories } ? $entity->product_categories->first->category_id : '';
    $c->service('product')->update_product_categories( $product_id, $selected_categories, $primary_category_id );
    return $c->render();
}

1;
