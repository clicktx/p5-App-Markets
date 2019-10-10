package Yetie::Controller::Admin::Product;
use Mojo::Base 'Yetie::Controller::Admin';

sub create {
    my $c = shift;

    my $new_product = $c->service('product')->new_product();
    $c->stash( product_id => $new_product->id );

    $c->template('admin/product/edit');
    return $c->edit();
}

# NOTE: 削除しないでtrashedにした方が良いか？
sub delete {
    my $c          = shift;
    my $product_id = $c->stash('product_id');

    # 販売済みの商品は削除不可
    my $bool = $c->service('product')->is_sold($product_id);
    return $c->reply->exception('Could not delete item.This item has already been sold.') if $bool;

    my $delete_product = $c->service('product')->remove_product($product_id);
    return $delete_product
      ? $c->redirect_to('rn.admin.products')
      : $c->reply->not_found();
}

sub duplicate {
    my $c = shift;

    my $product_id = $c->stash('product_id');
    my $result     = $c->service('product')->duplicate_product($product_id);
    return $result ? $c->redirect_to('rn.admin.products') : $c->reply->not_found();
}

sub edit {
    my $c = shift;

    my $product_id = $c->stash('product_id');
    my $product    = $c->service('product')->find_product($product_id);
    return $c->reply->not_found() if !$product->has_id;

    $c->stash( product => $product );

    # Init form
    my $form = $c->form('admin-product');
    $c->_form_default_value( $form, $product );

    my $choices = $product->product_categories->get_form_choices_primary_category;
    $form->field('primary_category')->choices($choices);
    $c->init_form();

    # Get request
    return $c->render() if $c->is_get_request;

    # Validation form
    return $c->render() if !$form->do_validate;

    # Update data
    $c->service('product')->update_product( $product_id, $form );
    return $c->render();
}

sub category {
    my $c = shift;

    my $product_id = $c->stash('product_id');
    my $product    = $c->service('product')->find_product($product_id);
    return $c->reply->not_found() if !$product->has_id;

    # Init form
    my $form         = $c->form('admin-product-category');
    my $category_ids = $product->product_categories->get_id_list;
    my $tree         = $c->service('category')->get_category_tree;
    my $choices      = $tree->get_attributes_for_choices_form($category_ids);
    $form->field('categories[]')->choices($choices);
    $c->init_form();

    # Get request
    return $c->render() if $c->is_get_request;

    # Validation form
    return $c->render() if !$form->do_validate;

    # Selected categories
    my $selected_categories = $form->every_param('categories[]');
    return $c->render() if !@{$selected_categories};

    my $product_categories = $product->product_categories;
    my $primary_category_id =
      $product_categories->has_elements ? $product_categories->primary_category->category_id : '';
    $c->service('product')->update_product_categories( $product_id, $selected_categories, $primary_category_id );
    return $c->render();
}

sub _form_default_value {
    my ( $c, $form, $product ) = @_;

    foreach my $name (qw/id title description/) {
        $form->field($name)->default_value( $product->$name );
    }
    $form->field('price')->default_value( $product->price->value );

    return $form;
}

1;
