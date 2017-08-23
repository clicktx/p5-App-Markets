package Markets::Controller::Admin::Product;
use Mojo::Base 'Markets::Controller::Admin';
use Try::Tiny;

has resultset => sub { shift->schema->resultset('Product') };

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

    my $product_id        = $self->stash('product_id');
    my $duplicate_product = $self->service('product')->duplicate_product($product_id);

    return $self->redirect_to('RN_admin_products');
}

sub edit {
    my $self = shift;

    my $product_id = $self->stash('product_id');
    my $entity     = $self->service('product')->create_entity($product_id);

    # Init form
    my $form = $self->form_set('admin-product');
    $self->form_default_value( $form, $entity );

    my $categories = $self->service('product')->get_primary_category_choices($entity);
    $form->field('primary_category')->choices($categories);
    $self->init_form();

    return $self->render() if !$form->has_data or !$form->validate;

    # Update data
    $self->service('product')->modify( $product_id, $form->params->to_hash );
    return $self->render();
}

sub category {
    my $self = shift;

    my $product_id = $self->stash('product_id');
    my $entity     = $self->service('product')->create_entity($product_id);

    # NOTE: 存在しないproduct_idの場合はエラーにする

    # Init form
    my $form = $self->form_set();

    my $category_ids = [];
    $entity->product_categories->each( sub { push @{$category_ids}, $_->category_id } );

    my $tree = $self->schema->resultset('Category')->get_tree_for_form( checked => $category_ids );
    $form->field('categories')->choices($tree);
    $self->init_form();

    return $self->render() if !$form->has_data or !$form->validate;

    my $param_categories = $form->param('categories[]');
    return $self->render() unless @{$param_categories};

    # primary category_id
    my $primary_category = $entity->product_categories->first;
    my $primary_category_id = $primary_category ? $primary_category->category_id : '';

    # NOTE: 通常は設定しているプライマリを引き継ぐ
    # 例外: パラメーターの最初のカテゴリをプライマリに設定
    # - 選択項目が1つの場合
    # - 複数指定でも取得したprimary_idが選択項目にない場合
    my $product_categories = [];
    my $has_primary;
    foreach my $cid ( @{$param_categories} ) {
        my $is_primary = 0;
        if ( $cid == $primary_category_id ) {
            $is_primary  = 1;
            $has_primary = 1;
        }
        push @{$product_categories},
          {
            product_id  => $product_id,
            category_id => $cid,
            is_primary  => $is_primary
          };
    }
    $product_categories->[0]->{is_primary} = 1 unless $has_primary;

    my $rs = $self->schema->resultset('Product::Category');
    my $cb = sub {
        $rs->search( { product_id => $product_id } )->delete;
        $rs->populate($product_categories);
    };
    try { $self->schema->txn_do($cb) }
    catch { $self->schema->txn_failed($_) };

    return $self->render();
}

1;
