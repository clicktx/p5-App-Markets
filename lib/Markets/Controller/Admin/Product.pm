package Markets::Controller::Admin::Product;
use Mojo::Base 'Markets::Controller::Admin';
use Try::Tiny;

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

        my $field = $form->field('title');
        my $title = $field->default_value . ' copy';
        $field->default_value($title);
    }
    $self->init_form();

    return $self->render() if $self->req->method eq 'GET';

    return $self->render() if !$form->has_data or !$form->validate;

    # Create new product
    my $params = $form->params->to_hash;
    $self->resultset->create($params);

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
    my $product = $self->resultset->find( $product_id, { prefetch => { categories => 'category' } } );

    # Init form
    my $form = $self->form_set('admin-product');
    $self->form_default_value( $form, $product );

    my @categories;
    my $itr = $self->schema->resultset('Product::Category')
      ->search( { product_id => $product_id }, { prefetch => 'category' } );
    while ( my $row = $itr->next ) {
        push @categories, [ $row->category->title, $row->category_id, checked => $row->is_primary ];
    }
    $form->field('primary_category')->choices( \@categories );
    $self->init_form();

    return $self->render() if !$form->has_data or !$form->validate;

    # Update data
    my $params = $form->params->to_hash;
    my $cb   = sub {

        # Primary category
        my $primary_category = delete $params->{primary_category};
        $product->categories->update( { is_primary => 0 } );
        $product->categories->search( { category_id => $primary_category } )->update( { is_primary => 1 } );

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

1;
