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

    my $title = 'New Product';
    my $int = $self->resultset->search( { title => { like => $title . '%' } } )->count;
    $title .= $int + 1;

    my $new_product = $self->resultset->create( { title => $title } );
    $self->stash( product_id => $new_product->id );

    $self->template('admin/product/edit');
    return $self->edit();
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
    my $entity     = $self->service('product')->create_entity($product_id);

    # Init form
    my $form = $self->form_set('admin-product');
    $self->form_default_value( $form, $entity );

    my @categories;
    $entity->product_categories->each(
        sub {
            my $ancestors = $self->schema->resultset('Category')->get_ancestors_arrayref( $_->id );
            my $title;
            foreach my $ancestor ( @{$ancestors} ) { $title .= $ancestor->{title} . ' > ' }
            $title .= $_->title;
            push @categories, [ $title, $_->id, checked => $_->is_primary ];
        }
    );
    $form->field('primary_category')->choices( \@categories );
    $self->init_form();

    return $self->render() if !$form->has_data or !$form->validate;

    # Update data
    my $product = $self->resultset->find( $product_id, { prefetch => { product_categories => 'detail' } } );
    my $params  = $form->params->to_hash;
    my $cb      = sub {

        # Primary category
        my $primary_category = delete $params->{primary_category};
        $product->product_categories->update( { is_primary => 0 } );
        $product->product_categories->search( { category_id => $primary_category } )->update( { is_primary => 1 } );

        # Product detail
        $product->update($params);
    };

    try { $self->schema->txn_do($cb) }
    catch {
        $self->schema->txn_failed($_);
        return;
    };

    return $self->render();
}

sub category {
    my $self = shift;

    my $product_id = $self->stash('product_id');

    # Init form
    my $form = $self->form_set();
    my $itr =
      $self->schema->resultset('Product::Category')->search( { product_id => $product_id } );

    my $category_ids = [];
    while ( my $row = $itr->next ) {
        push @{$category_ids}, $row->category_id;
    }

    my $tree = $self->schema->resultset('Category')->get_tree_for_form( checked => $category_ids );
    $form->field('categories')->choices($tree);
    $self->init_form();

    return $self->render() if !$form->has_data or !$form->validate;

    # Update data
    my $rs = $self->schema->resultset('Product::Category');

    # primary category_id
    my $primary = $rs->find( { product_id => $product_id, is_primary => 1 } );
    my $primary_id = $primary ? $primary->category_id : 0;
    $primary_id;

    my $params           = $form->params->to_hash;
    my $param_categories = $params->{'categories[]'};

    # NOTE: 通常は設定しているプライマリを引き継ぐ
    # 例外: パラメーターの最初のカテゴリをプライマリに設定
    # - 選択項目が1つの場合
    # - 複数指定でも取得したprimary_idが選択項目にない場合
    my $product_categories = [];
    my $has_primary;
    foreach my $cid ( @{$param_categories} ) {
        my $is_primary = 0;
        if ( $cid == $primary_id ) {
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

    my $cb = sub {
        $rs->search( { product_id => $product_id } )->delete;
        $rs->populate($product_categories);
    };
    try { $self->schema->txn_do($cb) }
    catch {
        $self->schema->txn_failed($_);
        return;
    };
    return $self->render();
}

1;
